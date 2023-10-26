import { defineConfig } from "tinacms";
import { postFields } from "./templates";

const BRANCH = process.env.HEAD || process.env.BRANCH_NAME || "main";
const CLIENT_ID = String(process.env.TINA_CLIENT_ID ?? '');
const TOKEN = String(process.env.TINA_TOKEN ?? '');

export default defineConfig({
  branch: BRANCH,
  clientId: CLIENT_ID,
  token: TOKEN,
  client: { skip: true },
  build: {
    outputFolder: "admin",
    publicFolder: "./",
  },
  media: {
    tina: {
      mediaRoot: "medias",
      publicFolder: "./",
    },
  },
  schema: {
    collections: [
      {
        format: "md",
        label: "Articles",
        name: "posts",
        path: "_posts",
        ui: {
          defaultItem: {
            author: "La rédaction",
            layout: "post",
          },
          filename: {
            readOnly: true,
            slugify: values => {
              return `${values?.date?.substring(0, 10) ||
                'xxxx'}-${values?.title?.toLowerCase().replace(/[^\w\s]/gi, '').replace(/ /g, '-').normalize('NFD').replace(/[\u0300-\u036f]/g, "")}`
            },
          },
        },
        fields: [
          {
            label: 'Titre',
            name: 'title',
            type: 'string',
            isTitle: true,
            required: true,
          },
          {
            label: "Date",
            name: "date",
            type: "datetime",
            required: true,
          },
          {
            label: "Image d'en-tête",
            name: 'image',
            type: 'image',
            required: true,
          },
          {
            label: 'Auteur',
            name: 'author',
            type: 'string',
            required: true,
          },
          {
            label: "Corps du document",
            name: "body",
            type: "rich-text",
            description: "This is the markdown body",
            isBody: true,
            required: true,
          },
          {
            label: 'Layout',
            name: 'layout',
            type: 'string',
            required: true,
            ui: { component: 'hidden' },
          },
        ],
      },
      {
        format: "md",
        label: "Formules",
        name: "formules",
        path: "_formulas",
        fields: [
          {
            type: "rich-text",
            name: "body",
            label: "Body of Document",
            description: "This is the markdown body",
            isBody: true,
          },
        ],
      },
      {
        format: "md",
        label: "Pages",
        name: "pages",
        path: "",
        match: {
          include: '{contact,charte-des-evenements,contact,events,index,nous-rejoindre,qui-sommes-nous}',
          exclude: '_posts',
          exclude: '_coworkers',
        },
        fields: [
          {
            label: 'Titre',
            name: 'title',
            type: 'string',
            isTitle: true,
            required: true,
          },
          {
            type: "rich-text",
            name: "body",
            label: "Body of Document",
            description: "This is the markdown body",
            isBody: true,
          },
        ],
      },
    ],
  },
});
