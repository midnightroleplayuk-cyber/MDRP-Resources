// This is the data used in admin panel > Market tab

import { ItemType } from "../components/Admin/Market/types";
import { SelectType } from "../types/types";

export const ApiShells: (SelectType & { preview: string; type: string })[] = [
  {
    label: "Acid Shell",
    preview: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/acid.jpg",
    type: "labs",
    value: "k4mb1_acid2_shell",
  },
  {
    label: "Weed Shell",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/a3e2807967ae87239c24c7d1686384bd80c4b37b.jpg",
    type: "labs",
    value: "k4weed_shell",
  },
  {
    label: "Meth Shell",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/2776d84ac66023cb1f1366b246f5bb45078c73da.jpg",
    type: "labs",
    value: "k4meth_shell",
  },
  {
    label: "Coke Shell",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/81867d88cc5c076fe39676fcb1e836de30301912.jpg",
    type: "labs",
    value: "k4coke_shell",
  },
  {
    label: "Laundry Shell",
    preview: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/laundromat.png",
    type: "labs",
    value: "k4mb1_laundry_shell",
  },
  {
    label: "Office 1",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/3c65f6fddb48aba7b2a2356d465ee7ba30aa819e.jpg",
    type: "offices",
    value: "k4mb1_furnishedoffice1_shell",
  },
  {
    label: "Office 2",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/0d983bf42c2d454b2a7b06264a923ca790c04bb8.jpg",
    type: "offices",
    value: "k4mb1_furnishedoffice2_shell",
  },
  {
    label: "Office 3",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/255068e8e47468f60725f7cc17749b6c3b8b1499.jpg",
    type: "offices",
    value: "k4mb1_furnishedoffice4_shell",
  },
  {
    label: "Office 4",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/982586ea46febfd68fa59ab66df266b346c1f537.jpg",
    type: "offices",
    value: "k4mb1_furnishedoffice5_shell",
  },
  {
    label: "Container",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/156c04ac052c92914eaad5de5c0af6b190e3be2f.jpg",
    type: "warehouse",
    value: "container2_shell",
  },
  {
    label: "Small Warehouse",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/667f243c847f4dc45672ecfc760c6c09c9f647f6.jpg",
    type: "warehouse",
    value: "stashhouse3_shell",
  },
  {
    label: "Big Warehouse",
    preview:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/4799957bdce82616dec7ad77b9987d10bb11157d.jpg",
    type: "warehouse",
    value: "stashhouse1_shell",
  },
];

export const ApiGangList: SelectType[] = [
  { value: "lossantosvagos", label: "Los Santos Vagos" },
  { value: "ballas", label: "Ballas" },
];

export const ApiIngredients: SelectType[] = [
  { value: "markedbills", label: "Marked Bills" },
  { value: "water", label: "Water" },
];

export const ApiLabsSettings: ItemType[] = [
  {
    enabled: true,
    category: "warehouse",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    label: "Container",
    level: 1,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/156c04ac052c92914eaad5de5c0af6b190e3be2f.jpg",
    price: 25000,
    shell: "container2_shell",
    upgrades: {
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
    },
  },
  {
    enabled: true,
    category: "warehouse",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    label: "Small Warehouse",
    level: 2,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/667f243c847f4dc45672ecfc760c6c09c9f647f6.jpg",
    price: 25000,
    shell: "stashhouse3_shell",
    upgrades: {
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
    },
  },
  {
    enabled: true,
    category: "warehouse",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    label: "Big Warehouse",
    level: 3,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/4799957bdce82616dec7ad77b9987d10bb11157d.jpg",
    price: 25000,
    shell: "stashhouse1_shell",
    upgrades: {
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
    },
  },
  {
    enabled: true,
    category: "offices",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    label: "Office 4",
    level: 3,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/982586ea46febfd68fa59ab66df266b346c1f537.jpg",
    price: 25000,
    shell: "k4mb1_furnishedoffice5_shell",
    upgrades: {
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
    },
  },
  {
    enabled: true,
    category: "offices",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    label: "Office 3",
    level: 2,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/255068e8e47468f60725f7cc17749b6c3b8b1499.jpg",
    price: 25000,
    shell: "k4mb1_furnishedoffice4_shell",
    upgrades: {
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
    },
  },
  {
    enabled: true,
    category: "offices",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    label: "Office 1",
    level: 1,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/3c65f6fddb48aba7b2a2356d465ee7ba30aa819e.jpg",
    price: 25000,
    shell: "k4mb1_furnishedoffice1_shell",
    upgrades: {
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
    },
  },
  {
    enabled: true,
    category: "offices",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    label: "Office 2",
    level: 1,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/0d983bf42c2d454b2a7b06264a923ca790c04bb8.jpg",
    price: 25000,
    shell: "k4mb1_furnishedoffice2_shell",
    upgrades: {
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
    },
  },
  {
    enabled: true,
    category: "labs",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    ingredients: ["drug_package"],
    label: "Acid Lab",
    level: 1,
    photo: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/acid.jpg",
    price: 25000,
    product: "weed_brick",
    shell: "k4mb1_acid2_shell",
    type: "drugs",
    upgrades: {
      production: {
        label: "Production",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "production",
      },
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
      stash: {
        label: "Stash Size",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "stash",
      },
    },
  },
  {
    enabled: true,
    category: "labs",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    ingredients: ["markedbills"],
    label: "Laundromat",
    level: 3,
    photo: "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/laundromat.png",
    price: 25000,
    product: "money",
    shell: "k4mb1_laundry_shell",
    type: "laundromat",
    upgrades: {
      production: {
        label: "Production",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "production",
      },
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
      stash: {
        label: "Stash Size",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "stash",
      },
    },
  },
  {
    enabled: true,
    category: "labs",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    ingredients: ["drug_package"],
    label: "Coke Lab",
    level: 3,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/81867d88cc5c076fe39676fcb1e836de30301912.jpg",
    price: 25000,
    product: "weed_brick",
    shell: "k4coke_shell",
    type: "drugs",
    upgrades: {
      production: {
        label: "Production",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "production",
      },
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
      stash: {
        label: "Stash Size",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "stash",
      },
    },
  },
  {
    enabled: true,
    category: "labs",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    ingredients: ["drug_package"],
    label: "Meth Lab",
    level: 2,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/2776d84ac66023cb1f1366b246f5bb45078c73da.jpg",
    price: 25000,
    product: "weed_brick",
    shell: "k4meth_shell",
    type: "drugs",
    upgrades: {
      production: {
        label: "Production",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "production",
      },
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
      stash: {
        label: "Stash Size",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "stash",
      },
    },
  },
  {
    enabled: true,
    category: "labs",
    description:
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Autem est earum itaque dolor a aut labore natus nemo ipsa totam?",
    ingredients: ["drug_package"],
    label: "Weed Lab",
    level: 1,
    photo:
      "https://dunb17ur4ymx4.cloudfront.net/wysiwyg/1027823/a3e2807967ae87239c24c7d1686384bd80c4b37b.jpg",
    price: 25000,
    product: "weed_brick",
    shell: "k4weed_shell",
    type: "drugs",
    upgrades: {
      production: {
        label: "Production",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "production",
      },
      security: {
        label: "Security",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "security",
      },
      stash: {
        label: "Stash Size",
        prices: [
          { level: 1, price: 2000 },
          { level: 2, price: 5000 },
          { level: 3, price: 10000 },
        ],
        value: "stash",
      },
    },
  },
];
