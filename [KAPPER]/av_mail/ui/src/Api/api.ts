import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import type {
  ApiResult,
  DomainsData,
  FullMessage,
  LaptopFile,
  MailItem,
  Profile,
} from "../types/types";

const RES = "av_mail";

const mockProfile: Profile = {
  address: "john@avscripts.com",
  username: "john",
  domain: "avscripts.com",
  displayName: "John Doe",
  avatar: null,
  unread: 2,
};

const mockItems: MailItem[] = [
  {
    itemId: 1,
    messageId: 1,
    fromAddress: "bank@avscripts.com",
    subject: "July account statement",
    preview: "Your monthly statement is ready to download.",
    createdAt: new Date().toISOString(),
    isRead: false,
    isStarred: true,
    box: "inbox",
    attachments: 1,
  },
  {
    itemId: 2,
    messageId: 2,
    fromAddress: "maria@taxi.com",
    subject: "Weekly shifts",
    preview: "Hi, here are the updated shifts for the team.",
    createdAt: new Date(Date.now() - 3600e3).toISOString(),
    isRead: true,
    isStarred: false,
    box: "inbox",
    attachments: 0,
  },
  {
    itemId: 3,
    messageId: 3,
    fromAddress: "support@avscripts.com",
    subject: "Welcome to AV Mail",
    preview: "Thanks for creating your account. Here are some tips.",
    createdAt: new Date(Date.now() - 86400e3).toISOString(),
    isRead: true,
    isStarred: false,
    box: "inbox",
    attachments: 0,
  },
];

const mockMessage: FullMessage = {
  itemId: 1,
  box: "inbox",
  isStarred: true,
  from: "bank@avscripts.com",
  subject: "July account statement",
  body: "Hi John,\n\nYour July account statement is ready. We attached the document for your review.\n\nBest,\nAV Bank",
  createdAt: new Date().toISOString(),
  to: ["john@avscripts.com"],
  attachments: [
    {
      id: 1,
      fileId: "f1",
      deviceSerial: "DEV1",
      name: "statement_july.pdf",
      type: "document",
      url: "#",
    },
  ],
};

const mockFiles: LaptopFile[] = [
  {
    id: "f1",
    name: "profile_photo.png",
    type: "image",
    url: "https://picsum.photos/seed/1/300/200",
  },
  { id: "f2", name: "contract.pdf", type: "document", url: "#" },
  { id: "f3", name: "clip.mp4", type: "video", url: "#" },
];

const mockDomains: DomainsData = {
  ok: true,
  owned: [
    {
      id: 2,
      domain: "taxi.com",
      price: 50000,
      created_at: new Date().toISOString(),
      mailboxes: [{ address: "maria@taxi.com", displayName: "Maria" }],
    },
  ],
  price: 50000,
  allowBuy: true,
};

async function call<T = ApiResult>(
  event: string,
  data?: any,
  mock?: T,
): Promise<T> {
  if (isEnvBrowser()) {
    return (mock ?? ({ ok: true } as any)) as T;
  }
  const res = await fetchNui<T>(RES, event, data);
  return (res ?? ({ ok: false, error: "errors.no_response" } as any)) as T;
}

export const api = {
  init: () =>
    call<ApiResult>("init", undefined, {
      ok: true,
      autoLogin: false,
      suggestedEmail: "john@avscripts.com",
    }),

  login: (address: string, password: string, authorize: boolean) =>
    call<ApiResult>(
      "login",
      { address, password, authorize },
      { ok: true, profile: mockProfile },
    ),

  signup: (payload: {
    username: string;
    domain: string;
    password: string;
    displayName: string;
  }) => call<ApiResult>("signup", payload, { ok: true, profile: mockProfile }),

  getSignupDomains: () =>
    call<string[]>("getSignupDomains", undefined, [
      "avscripts.com",
      "taxi.com",
    ]),

  logout: () => call<ApiResult>("logout", undefined, { ok: true }),

  getFolder: (folder: string) =>
    call<ApiResult>(
      "getFolder",
      { folder },
      {
        ok: true,
        items: folder === "trash" ? [] : mockItems,
      },
    ),

  openMessage: (id: number) =>
    call<ApiResult>("openMessage", { id }, { ok: true, message: mockMessage }),

  sendMail: (payload: {
    to: string;
    subject: string;
    body: string;
    attachments: any[];
  }) => call<ApiResult>("sendMail", payload, { ok: true }),

  forwardMail: (payload: {
    id: number;
    to: string;
    subject: string;
    body: string;
    attachments: any[];
  }) => call<ApiResult>("forwardMail", payload, { ok: true }),

  getMyFiles: () =>
    call<ApiResult>("getMyFiles", undefined, { ok: true, files: mockFiles }),

  downloadAttachment: (attachmentId: number) =>
    call<ApiResult>("downloadAttachment", { attachmentId }, { ok: true }),

  toggleStar: (id: number) =>
    call<ApiResult>("toggleStar", { id }, { ok: true, starred: true }),

  deleteMail: (id: number) =>
    call<ApiResult>("deleteMail", { id }, { ok: true }),

  getContacts: () =>
    call<ApiResult>("getContacts", undefined, {
      ok: true,
      contacts: [
        { id: 1, name: "Maria Lopez", email: "maria@taxi.com" },
        { id: 2, name: "AV Bank", email: "bank@avscripts.com" },
      ],
    }),

  addContact: (name: string, email: string) =>
    call<ApiResult>("addContact", { name, email }, { ok: true }),

  updateContact: (id: number, name: string, email: string) =>
    call<ApiResult>("updateContact", { id, name, email }, { ok: true }),

  deleteContact: (id: number) =>
    call<ApiResult>("deleteContact", { id }, { ok: true }),

  getDomains: () => call<DomainsData>("getDomains", undefined, mockDomains),

  buyDomain: (domain: string) =>
    call<ApiResult>("buyDomain", { domain }, { ok: true }),

  createMailbox: (domain: string, username: string, password: string) =>
    call<ApiResult>(
      "createMailbox",
      { domain, username, password },
      { ok: true },
    ),

  deleteMailbox: (address: string) =>
    call<ApiResult>("deleteMailbox", { address }, { ok: true }),

  updateProfile: (displayName: string, avatar: string) =>
    call<ApiResult>(
      "updateProfile",
      { displayName, avatar },
      { ok: true, profile: mockProfile },
    ),

  changePassword: (current: string, newPassword: string) =>
    call<ApiResult>("changePassword", { current, newPassword }, { ok: true }),
};
