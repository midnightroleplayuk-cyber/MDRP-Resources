import { Box, LoadingOverlay } from "@mantine/core"
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { Header } from "./Header";
import { CryptoList } from "./CryptoList";
import './cupcake.css'
import { selectHeight } from "../reducers/height";
import { useAppSelector } from "../hooks/reduxHooks";
import { useEffect, useState } from "react";

export const Cupcake = () => {
  const {height} = useAppSelector(selectHeight)
  const [allCryptos, setAllCryptos] = useState([])
  const [loaded, setLoaded] = useState(false)
  const updateCryptos = (data:any) => {
    setAllCryptos(data)
  }
  useEffect(() => {
    const fetchCrypto = async () => {
      const resp = await fetchNui("av_cupcake", "getCryptos")
      if(resp) {
        setAllCryptos(resp)
        setTimeout(() => {
          setLoaded(true)
        }, 100);
      } else {
            console.log("Some accounts are NOT registered in your server, this is NOT a script problem, please report it to the server admin")
            console.log("Some accounts are NOT registered in your server, this is NOT a script problem, please report it to the server admin")
            console.log("Some accounts are NOT registered in your server, this is NOT a script problem, please report it to the server admin")
            fetchNui("av_laptop", "sendNotification", {
              title: "APP ERROR",
              msg: "This app can't be loaded, verify F8 console for more info about this.",
              type: "error"
            })
      }
    }
    fetchCrypto()
  }, [])
  
  return (
    <Box className="cupcake" h={isEnvBrowser() ? "100%" : "calc(100vh)"}>
      {loaded ?
        <Box display={"block"} className="container" w={400}>
          <Header height={height}/>
          <CryptoList allCryptos={allCryptos} updateCryptos={updateCryptos}/>
        </Box>
      :
        <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
          <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
        </Box>
      }
    </Box>
  )
}