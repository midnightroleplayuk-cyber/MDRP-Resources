import { ChatType } from "../../../types/types";

export const sortMessages = (chatArray: ChatType[]): ChatType[] => {
  return chatArray.slice().sort((a, b) => {
    return a.date - b.date;
  });
};

export const formatTimestampToTime = (date: number): string => {
  const dateObject = new Date(date);
  const hours = String(dateObject.getHours()).padStart(2, "0");
  const minutes = String(dateObject.getMinutes()).padStart(2, "0");
  return `${hours}:${minutes}`;
};
