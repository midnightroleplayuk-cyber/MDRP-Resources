import {Group, Image, Flex, Text} from "@mantine/core"
import { useAppSelector } from "../hooks/reduxHooks"
import { selectLang } from "../reducers/language"

export const Header = ({height}:any) => {
  const {lang}:any = useAppSelector(selectLang)
  return (
    <Group 
      className="crypto-header"
      gap="md" 
      >
        <Image src="./logo.png" w={height > 1000 ? 50 : 30} />
        <Flex
            gap="0"
            justify="flex-start"
            align="start"
            direction="column"
            wrap="wrap"
        >
          <Text size={height > 1000 ? "md" : "sm"} fw={500}>{lang.app_header}</Text>
          <Text size={height > 1000 ? "sm" : "xs"} c="dimmed">{lang.app_subheader}</Text>
        </Flex>
    </Group>
  )
}