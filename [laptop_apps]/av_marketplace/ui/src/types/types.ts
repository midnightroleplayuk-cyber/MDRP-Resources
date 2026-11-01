export interface SelectType {
  value: string;
  label: string;
}

interface ModalOptions {
  name?: string;
  type: string;
  image?: string;
  width?: number;
  height?: number;
  title?: string;
  default?: string | number | boolean | string[];
  icon?: string;
  style?: React.CSSProperties;
  searchable?: boolean;
  description?: string;
  options?: SelectType[];
  size?: string;
  color?: string;
  disabled?: boolean;
  asterisk?: boolean;
  min?: number;
  decimal?: boolean;
  negative?: boolean;
  zero?: boolean;
  isMoney?: boolean;
}

export interface ModalType {
  state: boolean;
  info?: {
    size?: string;
    title?: string;
    options: ModalOptions[];
    button?: string;
    extraData?: any;
  };
  callback?: (data: any) => void;
}

export interface CategoryType {
  value: string;
  label: string;
  count: number;
}

export interface MarketItem {
  post_id: string;
  owner: string;
  category: string;
  title: string;
  price: number;
  description: string;
  image: string;
  tags?: any;
  seller: string;
  rating: number;
  created_at: number;
}

export interface Conversation {
  id: number;
  conversation_id: string;
  username: string;
  avatar: string;
  post_id: string;
  buyer: string;
  seller: string;
  last_message: string | null;
  updated_at: number;
  unread: number;
  post: {
    post_id: string;
    title: string;
    price: number;
    image: string;
    created_at: number;
  };
}

export interface Message {
  id: number;
  conversation_id: string;
  sender: string;
  message: string;
  type: "text" | "offer" | "system";
  metadata: string | null;
  is_read: 0 | 1;
  created_at: number;
}
