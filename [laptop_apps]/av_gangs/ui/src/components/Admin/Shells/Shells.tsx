import { Stack, Group, Text, Button, Grid } from "@mantine/core";
import { useEffect, useState } from "react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiAnimations, ApiPeds, ApiShells } from "../../../api/Shells";
import { ShellType, ExtraDataType } from "./types";
import { Loading } from "../../Loading";
import {
  ApiModal,
  getAnimationsForSelect,
  getPedsForSelect,
  getShellsForSelect,
  splitAnimData,
} from "./helpers";
import { ModalType, SelectType } from "../../../types/types";
import { ModalMenu } from "../../ModalMenu/ModalMenu";
import ShellManager from "./ShellManager";
import ShellDetails from "./ShellDetails";
import PedManager from "./PedManager";
import ZoneManager from "./ZoneManager";

const Shells = () => {
  const [loaded, setLoaded] = useState(false);
  const [allShells, setAllShells] = useState<ShellType[]>([]);
  const [shellOptions, setShellOptions] = useState<SelectType[]>([]);
  const [currentShell, setCurrentShell] = useState<ShellType | null>(null);
  const [pedOptions, setPedOptions] = useState<SelectType[]>([]);
  const [animOptions, setAnimOptions] = useState<SelectType[]>([]);
  const [modal, setModal] = useState<ModalType>(ApiModal);
  const [updatePeds, setUpdatePeds] = useState(false);

  const fetchData = async () => {
    const resp = await fetchNui("av_gangs", "getAdminShells");
    if (resp) {
      setAllShells(resp.shells);
      const shellsOptions = getShellsForSelect(resp.shells);
      setShellOptions(shellsOptions);
      const animOptions = getAnimationsForSelect(resp.animations);
      setAnimOptions(animOptions);
      const pedOptions = getPedsForSelect(resp.peds);
      setPedOptions(pedOptions);
    } else {
      if (isEnvBrowser()) {
        setAllShells(ApiShells);
        const shellsOptions = getShellsForSelect(ApiShells);
        setShellOptions(shellsOptions);
        const animOptions = getAnimationsForSelect(ApiAnimations);
        setAnimOptions(animOptions);
        const pedOptions = getPedsForSelect(ApiPeds);
        setPedOptions(pedOptions);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };

  const handleCallback = (data: any) => {
    setModal({ ...modal, state: false });
    if (!data || !currentShell) return;
    const { extraData, ...updateFields } = data as {
      extraData: ExtraDataType;
      [key: string]: any;
    };
    if (extraData.type === "peds" || extraData.type === "interactions") {
      const field = extraData.type as keyof ShellType;
      const index = extraData.index;

      setCurrentShell((prevShell) => {
        if (!prevShell) return null;

        const updatedShell = { ...prevShell };
        const updatedArray = [...(updatedShell[field] as any[])];
        const itemToUpdate = { ...updatedArray[index] };
        if (updateFields.model) {
          itemToUpdate.model = updateFields.model;
        }
        if (updateFields.animData) {
          const [dictionary, animation] = splitAnimData(updateFields.animData);
          itemToUpdate.dict = dictionary;
          itemToUpdate.animation = animation;
        }
        if (updateFields.label) {
          itemToUpdate.label = updateFields.label;
        }

        updatedArray[index] = itemToUpdate;
        (updatedShell as any)[field] = updatedArray;

        return updatedShell;
      });
      if (extraData.type === "peds") {
        setUpdatePeds(true);
      }
    }
  };

  const handleNew = async (type: string, data?: any) => {
    if (type == "newinteraction" || type == "newped") {
      const resp = await fetchNui("av_gangs", type, data);
      if (!resp) return;
      const field = type == "newinteraction" ? "interactions" : "peds";
      setCurrentShell((prevShell) => {
        if (!prevShell) {
          return null;
        }
        const existingArray =
          prevShell?.[field as keyof typeof prevShell] ?? [];
        const newArray = [...(existingArray as any[]), resp];
        return {
          ...prevShell,
          [field]: newArray,
        };
      });
      if (type == "newped") {
        setUpdatePeds(true);
      }
    }
  };
  const handleUpdate = (field: string, value: any) => {
    setCurrentShell((prevShell) => {
      const newShell = prevShell ? { ...prevShell } : {};
      (newShell as any)[field] = value;
      return newShell as ShellType;
    });
  };

  const handleUpdateDoor = (field: string, value: number) => {
    setCurrentShell((prevShell) => {
      if (!prevShell) {
        return null;
      }
      const newShell = { ...prevShell };
      const newDoor = { ...newShell.door };
      (newDoor as any)[field] = value;
      newShell.door = newDoor;
      return newShell;
    });
  };

  const handleSelect = (input: string | null) => {
    fetchNui("av_gangs", "destroyInterior");
    if (!input) {
      setCurrentShell(null);
      return;
    }
    const found = allShells.find((shell) => shell.shell === input);
    if (!found) return;
    setCurrentShell(found);
  };

  const deleteShell = async () => {
    fetchNui("av_gangs", "destroyInterior");
    setCurrentShell(null);
    const resp = await fetchNui("av_gangs", "deleteShell", currentShell?.shell);
    if (!resp) return;
    const shellsOptions = getShellsForSelect(resp);
    setShellOptions(shellsOptions);
    setAllShells(resp);
  };

  const handleSave = async () => {
    const resp = await fetchNui("av_gangs", "updateShell", currentShell);
    if (!resp) return;
    const shellsOptions = getShellsForSelect(resp);
    setShellOptions(shellsOptions);
    setAllShells(resp);
  };
  const handlePeds = async () => {
    setUpdatePeds(false);
    if (!currentShell?.peds) return;
    const resp = await fetchNui("av_gangs", "togglePeds", currentShell?.peds);
    if (!resp) return;
    setCurrentShell((prevShell) => {
      const newShell = prevShell ? { ...prevShell } : {};
      (newShell as any)["peds"] = resp;
      return newShell as ShellType;
    });
  };
  const handleDelete = (type: string, index: number) => {
    setCurrentShell((prevShell) => {
      if (!prevShell) {
        return null;
      }
      const updatedShell = { ...prevShell };
      const field = type as keyof typeof updatedShell;
      if (Array.isArray(updatedShell[field])) {
        if (type === "peds") {
          const pedInfo = (updatedShell[field] as any[])[index];
          fetchNui("av_gangs", "deletePed", pedInfo.entity);
          setUpdatePeds(true);
        }
        const updatedZones = (updatedShell[field] as any[]).filter(
          (_, i) => i !== index
        );
        (updatedShell as any)[field] = updatedZones;
      }
      return updatedShell;
    });
  };
  const handleDoor = async () => {
    const resp = await fetchNui("av_gangs", "getDoorOffset");
    if (resp) {
      handleUpdate("door", resp);
    }
  };

  useEffect(() => {
    if (!loaded) {
      fetchData();
    }
    if (currentShell?.peds && updatePeds) {
      handlePeds();
    }
  }, [updatePeds]);

  if (!loaded) return <Loading />;
  return (
    <>
      {modal.state && <ModalMenu data={modal} />}
      <Stack p="md">
        <ShellManager
          shellOptions={shellOptions}
          currentShell={currentShell}
          handleSelect={handleSelect}
          handleSave={handleSave}
          handleDelete={deleteShell}
        />
        <Grid>
          <Grid.Col>
            <ShellDetails
              currentShell={currentShell}
              handleUpdate={handleUpdate}
              handleUpdateDoor={handleUpdateDoor}
              handleDoor={handleDoor}
            />
          </Grid.Col>
          <PedManager
            currentShell={currentShell}
            pedOptions={pedOptions}
            animOptions={animOptions}
            handleNew={handleNew}
            handleDelete={handleDelete}
            setModal={setModal}
            handleCallback={handleCallback}
          />
          <ZoneManager
            currentShell={currentShell}
            handleNew={handleNew}
            handleDelete={handleDelete}
            setModal={setModal}
            handleCallback={handleCallback}
          />
        </Grid>
      </Stack>
    </>
  );
};

export default Shells;
