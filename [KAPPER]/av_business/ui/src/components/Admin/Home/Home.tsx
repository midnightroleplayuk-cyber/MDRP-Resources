import { Stack } from "@mantine/core";
import { Header } from "./Header";
import { useState } from "react";
import { SelectType } from "../../../types/types";
import { Overview } from "./Overview/Overview";
import { Zones } from "./Zones/Zones";
import { Products } from "./Products/Products";

interface Properties {
  allJobs: SelectType[];
}

const Home = ({ allJobs }: Properties) => {
  const [job, setJob] = useState<string | null>(null);
  const [tab, setTab] = useState("");

  const handleJob = (name: string | null) => {
    setTab("overview");
    setJob(name);
  };
  return (
    <Stack>
      <Header
        allJobs={allJobs}
        setJob={handleJob}
        job={job}
        setTab={setTab}
        tab={tab}
      />
      {tab == "overview" && <Overview job={job} />}
      {tab == "zones" && <Zones job={job} />}
      {tab == "products" && <Products job={job} />}
    </Stack>
  );
};

export default Home;
