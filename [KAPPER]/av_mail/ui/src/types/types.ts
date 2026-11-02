export interface Profile {
  address: string;
  username: string;
  domain: string;
  displayName: string;
  avatar?: string | null;
  unread: number;
  maxBody?: number;
  maxSubject?: number;
  maxBodyImages?: number;
  imageHosts?: string[];
}

export type FolderKey = "inbox" | "sent" | "starred" | "trash";
export type ScreenKey = "mail" | "domains" | "settings" | "contacts" | "admin";

export interface Contact {
  id: number;
  name: string;
  email: string;
}
export type AttachmentType = "image" | "video" | "document";

export interface MailItem {
  itemId: number;
  messageId: number;
  fromAddress: string;
  subject: string;
  preview: string;
  createdAt: string | number;
  isRead: boolean;
  isStarred: boolean;
  box: string;
  attachments: number;
}

export interface Attachment {
  id: number;
  fileId: string;
  deviceSerial: string;
  name: string;
  type: AttachmentType;
  url: string;
}

export interface FullMessage {
  itemId: number;
  box: string;
  isStarred: boolean;
  from: string;
  fromName?: string | null;
  fromAvatar?: string | null;
  subject: string;
  body: string;
  createdAt: string | number;
  to: string[];
  attachments: Attachment[];
}

export interface LaptopFile {
  id: string;
  name: string;
  type: AttachmentType;
  url: string;
}

export interface Mailbox {
  address: string;
  displayName: string;
}

export interface OwnedDomain {
  id: number;
  domain: string;
  price: number;
  created_at: string;
  mailboxes: Mailbox[];
}

export interface DomainsData {
  ok: boolean;
  owned: OwnedDomain[];
  price: number;
  allowBuy: boolean;
}

export interface ApiResult<T = any> {
  ok: boolean;
  error?: string;
  errorParams?: Record<string, string | number>;
  [key: string]: any;
}
