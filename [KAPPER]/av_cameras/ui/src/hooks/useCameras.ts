import { useState, useEffect } from "react";
import { CameraType, ModalType, SelectType, ViewMode } from "../types/types";
import { fetchNui, isEnvBrowser } from "./useNuiEvents";
import { ApiGroups } from "../Api/Groups";
import { ApiCameras } from "../Api/Cameras";
import { useSetAtom, useAtomValue } from "jotai";
import { isBoss, Lang } from "../reducers/atoms";

export const useCameras = () => {
  const lang: any = useAtomValue(Lang);
  const [view, setView] = useState<ViewMode>("grid");
  const [allGroups, setAllGroups] = useState<SelectType[]>([]);
  const [allCameras, setAllCameras] = useState<CameraType[]>([]);
  const [filtered, setFiltered] = useState<CameraType[]>([]);
  const [filteredBy, setFilteredBy] = useState("all");
  const [myCoords, setMyCoords] = useState({ x: 0, y: 0 });
  const setBoss = useSetAtom(isBoss);
  const [connection, setConnection] = useState({
    connecting: false,
    cameraLabel: "",
  });
  const [modalData, setModalData] = useState<ModalType>({
    state: false,
  });

  const handleConnection = async (camera: CameraType) => {
    if (camera.battery == 0) {
      fetchNui("av_cameras", "batteryDead");
      return;
    }
    setConnection({ connecting: true, cameraLabel: camera.label });
    if (isEnvBrowser()) {
      setTimeout(() => {
        setConnection({ connecting: false, cameraLabel: "" });
      }, 2000);
      return;
    }
    fetchNui("av_cameras", "connectCamera", {
      identifier: camera.identifier,
    });
    setTimeout(() => {
      setConnection({ connecting: false, cameraLabel: "" });
    }, 2000);
  };

  const processRename = (type: string, identifier: string, name: string) => {
    if (type == "group") {
      const updatedGroups = allGroups.map((group) =>
        group.value === identifier ? { ...group, label: name } : group,
      );
      setAllGroups(updatedGroups);
    } else if (type === "camera") {
      const updatedCameras = allCameras.map((camera) =>
        camera.identifier === identifier ? { ...camera, label: name } : camera,
      );
      setAllCameras(updatedCameras);
      setFiltered(updatedCameras);
    }
    fetchNui("av_cameras", "rename", {
      type,
      identifier,
      name,
    });
  };

  const handleNewGroup = async (name: string) => {
    const newGroupId = await fetchNui("av_cameras", "addGroup", name);
    if (!newGroupId) return;
    const newGroup = { value: newGroupId, label: name };
    const updatedGroups = [...allGroups, newGroup];
    setAllGroups(updatedGroups);
  };

  const handleCallback = (data: any) => {
    setModalData({ state: false });
    if (!data) return;
    const { extraData } = data;
    switch (extraData.action) {
      case "addGroup":
        handleNewGroup(data.name);
        break;
      case "clipboard":
        fetchNui("av_laptop", "copy", extraData.value);
        break;
      case "remove":
        if (extraData.type === "group") {
          const updatedGroups = allGroups.filter(
            (group) => group.value !== extraData.identifier,
          );
          setAllGroups(updatedGroups);
          setFilteredBy("all");
          setFiltered(allCameras);
        } else if (extraData.type === "camera") {
          fetchNui("av_cameras", "removeCamera", extraData.identifier);
          const updated = allCameras.filter(
            (camera) => camera.identifier !== extraData.identifier,
          );
          setAllCameras(updated);
          if (filteredBy === "all") {
            setFiltered(updated);
            return;
          }
          setFiltered(
            updated.filter((camera) => camera.group_id === filteredBy),
          );
        }
        break;
      case "rename":
        if (extraData.type === "group") {
          processRename("group", extraData.identifier, data.name);
        } else if (extraData.type === "camera") {
          processRename("camera", extraData.identifier, data.name);
        }
        break;
      case "share":
        fetchNui("av_cameras", "share", {
          type: extraData.type,
          identifier: extraData.identifier,
          playerId: data.playerId,
          label: data.label,
        });
        break;
    }
  };

  const handleFiltered = (type: string) => {
    setFilteredBy(type);
    switch (type) {
      case "all":
        setFiltered(allCameras);
        break;
      case "vehicle":
        setFiltered(allCameras.filter((camera) => camera.type === "vehicle"));
        break;
      case "live":
        setFiltered(allCameras.filter((camera) => camera.status === "live"));
        break;
      default:
        setFiltered(allCameras.filter((camera) => camera.group_id === type));
        break;
    }
  };

  const handleSearch = (query: string) => {
    const lowerQuery = query.toLowerCase();
    const searchedCameras = allCameras.filter(
      (camera) =>
        camera.label.toLowerCase().includes(lowerQuery) ||
        camera.identifier.toLowerCase().includes(lowerQuery) ||
        camera.location.toLowerCase().includes(lowerQuery) ||
        camera.group_id?.toLowerCase().includes(lowerQuery),
    );
    setFiltered(searchedCameras);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_cameras", "getCameras");
      if (resp) {
        setBoss(resp.isBoss);

        const sortedCameras = [...resp.cameras].sort((a, b) =>
          a.label.localeCompare(b.label),
        );
        const sortedGroups = [...resp.groups].sort((a, b) =>
          a.label.localeCompare(b.label),
        );
        setAllCameras(sortedCameras);
        setFiltered(sortedCameras);
        setMyCoords(resp.coords);
        setAllGroups(sortedGroups);
      } else {
        setFiltered(ApiCameras);
        setAllCameras(ApiCameras);
        setAllGroups(ApiGroups);
      }
    };
    fetchData();
  }, []);

  const handleRename = (camera: CameraType) => {
    setModalData({
      state: true,
      info: {
        title: lang.rename_camera,
        options: [
          {
            type: "text",
            name: "name",
            title: lang.new_camera_name,
            max: 30,
          },
        ],
        extraData: {
          action: "rename",
          type: "camera",
          identifier: camera.identifier,
        },
        button: lang.confirm,
      },
    });
  };

  const handleSendToGroup = (identifier: string, targetGroup: string) => {
    const updatedCameras = allCameras.map((camera) =>
      camera.identifier === identifier
        ? {
            ...camera,
            group_id: targetGroup === "none" ? undefined : targetGroup,
          }
        : camera,
    );
    fetchNui("av_cameras", "sendToGroup", {
      identifier,
      targetGroup,
    });
    setAllCameras(updatedCameras);
    setFiltered(updatedCameras);
  };

  const handleShare = (identifier: string) => {
    setModalData({
      state: true,
      info: {
        title: lang.share_camera,
        options: [
          {
            name: "playerId",
            type: "number",
            size: "xs",
            min: 1,
            max: 9999,
            decimal: false,
            title: lang.player_server_id_to_share_with,
            description: lang.player_id,
          },
          {
            name: "label",
            type: "text",
            size: "xs",
            max: 30,
            title: lang.display_name,
            description: lang.name,
          },
        ],
        button: lang.send,
        extraData: {
          action: "share",
          type: "camera",
          identifier,
        },
      },
    });
  };

  const handleRemove = (identifier: string) => {
    setModalData({
      state: true,
      info: {
        title: lang.remove_camera,
        options: [
          {
            type: "info",
            description: lang.delete_camera_confirmation,
            size: "xs",
          },
        ],
        button: lang.confirm,
        extraData: {
          action: "remove",
          type: "camera",
          identifier,
        },
      },
    });
  };

  const handleRemoveGroup = (groupId: string) => {
    fetchNui("av_cameras", "removeGroup", groupId);
    const updatedGroups = allGroups.filter((group) => group.value !== groupId);
    setAllGroups(updatedGroups);
    setFilteredBy("all");
    setFiltered(allCameras);
  };

  return {
    view,
    setView,
    allGroups,
    allCameras,
    filtered,
    filteredBy,
    myCoords,
    connection,
    modalData,
    setModalData,
    handleConnection,
    handleCallback,
    handleFiltered,
    handleSearch,
    handleRename,
    handleSendToGroup,
    handleShare,
    handleRemove,
    handleRemoveGroup,
  };
};
