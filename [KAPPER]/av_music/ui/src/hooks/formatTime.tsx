export const FormatTime = ({ milli }: any) => {
  const milliseconds = milli % 1000;
  const seconds = Math.floor((milli / 1000) % 60);
  let minutes: any = Math.floor((milli / (60 * 1000)) % 60);
  minutes = minutes < 10 ? "0" + minutes : minutes;
  const formattedSeconds = seconds < 10 ? "0" + seconds : seconds;
  return (
    <div>{`${minutes}:${formattedSeconds}:${String(milliseconds).slice(
      0,
      2,
    )}`}</div>
  );
};
