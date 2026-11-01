import {
  Group,
  Text,
  ScrollArea,
  Grid,
  Card,
  Image,
  ActionIcon,
  Tooltip,
  Rating,
  Badge,
} from "@mantine/core";
import { useEffect, useState } from "react";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { PropertyType, UpgradeKeys } from "./types";
import {
  IconMapPinShare,
  IconCashMoveBack,
  IconProgressCheck,
  IconCoin,
} from "@tabler/icons-react";
import { ApiProperties } from "../../../api/Properties";
import classes from "./style.module.css";
import { Loading } from "../../Loading";
import { getImages } from "./helpers";
import { useRecoilValue } from "recoil";
import { Gang, Lang, Permissions } from "../../../reducers/atoms";
import { Icons } from "./IconsComponent";
import { calculateLevel } from "../../../hooks/calculateLevel";
import { ModalMenu } from "../../ModalMenu/ModalMenu";
import { ModalType } from "../../../types/types";

const Properties = () => {
  const lang: any = useRecoilValue(Lang);
  const permissions = useRecoilValue(Permissions);
  const { level, max, name } = useRecoilValue(Gang);
  const [loaded, setLoaded] = useState(false);
  const [allProperties, setAllProperties] = useState<
    (PropertyType & { photo?: string })[]
  >([]);

  const calculatedLevel = calculateLevel(level, max);
  const [currentProperty, setCurrentProperty] = useState({
    type: "",
    identifier: "",
    price: 0,
  });

  useNuiEvent(
    "updateLab",
    (data: { identifier: string; working: string; color: string }) => {
      setAllProperties((prevProperties) =>
        prevProperties.map((property) =>
          property.identifier === data.identifier
            ? {
                ...property,
                working: data.working,
                color: data.color,
              }
            : property
        )
      );
    }
  );

  const [modal, setModal] = useState<ModalType>({
    state: false,
    info: {
      title: lang.resell_title,
      options: [
        {
          type: "info",
          description: lang.resell_confirmation,
          size: "xs",
        },
      ],
      button: lang.confirm,
    },
  });
  const callback = async (data: any) => {
    setModal({ ...modal, state: false });
    if (!data) return;
    fetchNui("av_gangs", "sellProperty", currentProperty);
    setAllProperties((prevProperties) =>
      prevProperties.filter(
        (property) => property.identifier !== currentProperty.identifier
      )
    );
  };
  const handleUpgrade = async (
    identifier: string,
    type: string,
    shell: string,
    upgrade: string,
    level: number
  ) => {
    const resp = await fetchNui("av_gangs", "buyUpgrade", {
      identifier,
      type,
      shell,
      upgrade,
      level,
    });
    if (resp) {
      setAllProperties((prevProperties) =>
        prevProperties.map((property) =>
          property.identifier === identifier
            ? {
                ...property,
                upgrades: {
                  ...property.upgrades,
                  [upgrade]: level,
                },
              }
            : property
        )
      );
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "getProperties");
      if (resp) {
        const ready = getImages(resp.properties, resp.shells);
        setAllProperties(ready);
      } else {
        if (isEnvBrowser()) {
          setAllProperties(ApiProperties);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <>
      {modal.state && <ModalMenu data={modal} callback={callback} />}
      <Group className={classes.card} p="md">
        <Text
          fz="1.35rem"
          c="white"
          ff="Bebas Neue"
          fw={500}
          lts={1.55}
        >{`${allProperties.length} ${lang.properties}`}</Text>
      </Group>
      <ScrollArea
        className={classes.scroll}
        offsetScrollbars
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
        mt="sm"
      >
        <Grid>
          {allProperties.map((property) => (
            <Grid.Col key={property.identifier} maw={255}>
              <Card withBorder radius="md" className={classes.card} h={315}>
                <Card.Section>
                  <Image
                    src={property.photo}
                    h={120}
                    fallbackSrc="mission_default.webp"
                    fit="cover"
                  />
                </Card.Section>
                <Group>
                  <Tooltip label={property.label} color="dark.5">
                    <Text
                      mt="xs"
                      fw={500}
                      truncate
                      ff="Bebas Neue"
                      fz="1.35rem"
                      lts={1.5}
                      maw={120}
                    >
                      {property.label}
                    </Text>
                  </Tooltip>
                  {property.type == "labs" && (
                    <Badge
                      size="xs"
                      mt="6"
                      variant="transparent"
                      tt="capitalize"
                      ml="auto"
                      lts={1.5}
                      color={property.color}
                    >
                      {property.working}
                    </Badge>
                  )}
                </Group>
                <Card.Section p="sm">
                  <Text
                    c="dimmed"
                    fz="9px"
                    tt="uppercase"
                    fw={600}
                    lts={2}
                    ml="9"
                  >
                    {lang.upgrades}
                  </Text>
                  <Group mt={"xs"} justify="center" gap={8}>
                    {(Object.keys(property.upgrades) as UpgradeKeys[]).map(
                      (upgrade: UpgradeKeys) => (
                        <Group key={upgrade} gap="xs">
                          <Tooltip
                            label={lang.upgrades_titles[upgrade]}
                            color="dark.5"
                            fz="xs"
                          >
                            <Text>{Icons[upgrade]}</Text>
                          </Tooltip>
                          <Rating
                            value={property.upgrades[upgrade]}
                            count={3}
                            emptySymbol={<IconCoin color="gray" size={16} />}
                            size="14px"
                            fullSymbol={(value: number) => {
                              const priceInfo =
                                property.availableUpgrades[upgrade].prices[
                                  value - 1
                                ];
                              return (
                                <Tooltip
                                  fw={500}
                                  fz="xs"
                                  color="dark.5"
                                  c="gray.3"
                                  label={
                                    priceInfo &&
                                    calculatedLevel.level >= priceInfo.level
                                      ? `${
                                          lang.money_symbol
                                        }${priceInfo.price.toLocaleString(
                                          "en-US"
                                        )}`
                                      : `${lang.requiredLevel} ${priceInfo?.level}`
                                  }
                                  withinPortal
                                  disabled={value <= property.upgrades[upgrade]}
                                >
                                  <IconCoin color="#38D9A9" size={16} />
                                </Tooltip>
                              );
                            }}
                            readOnly={property.upgrades[upgrade] === 3}
                            onChange={(value) => {
                              const priceInfo =
                                property.availableUpgrades[upgrade].prices[
                                  value - 1
                                ];
                              if (
                                priceInfo &&
                                (value <= property.upgrades[upgrade] ||
                                  calculatedLevel.level < priceInfo.level)
                              )
                                return;
                              handleUpgrade(
                                property.identifier,
                                property.type,
                                property.shell,
                                upgrade,
                                value
                              );
                            }}
                          />
                        </Group>
                      )
                    )}
                  </Group>
                </Card.Section>
                <Card.Section
                  p="sm"
                  style={{
                    position: "absolute",
                    bottom: 0,
                    marginBottom: 0,
                    width: "100%",
                  }}
                >
                  <Group>
                    <Tooltip label={lang.set_waypoint} color="dark.5">
                      <ActionIcon
                        variant="transparent"
                        size="xs"
                        ml="auto"
                        color="cyan.3"
                        onClick={() => {
                          fetchNui("av_laptop", "setGPS", {
                            x: property.entry.x,
                            y: property.entry.y,
                            z: property.entry.z,
                          });
                        }}
                      >
                        <IconMapPinShare />
                      </ActionIcon>
                    </Tooltip>
                    {property.type == "labs" && (
                      <Tooltip label={lang.process_lab} color="dark.5">
                        <ActionIcon
                          variant="transparent"
                          size="xs"
                          color="teal.3"
                          onClick={() => {
                            fetchNui("av_gangs", "processLab", {
                              identifier: property.identifier,
                              name,
                            });
                          }}
                        >
                          <IconProgressCheck />
                        </ActionIcon>
                      </Tooltip>
                    )}
                    {permissions.isBoss && (
                      <Tooltip label={lang.sell_property} color="dark.5">
                        <ActionIcon
                          variant="transparent"
                          size="xs"
                          color="red.3"
                          onClick={() => {
                            setCurrentProperty({
                              type: property.type,
                              identifier: property.identifier,
                              price: property.originalPrice / 2,
                            });
                            setModal({ ...modal, state: true });
                          }}
                        >
                          <IconCashMoveBack />
                        </ActionIcon>
                      </Tooltip>
                    )}
                  </Group>
                </Card.Section>
              </Card>
            </Grid.Col>
          ))}
        </Grid>
      </ScrollArea>
    </>
  );
};

export default Properties;
