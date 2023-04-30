import { defineConfig } from "tinacms";
import { postFields } from "./templates";

const BRANCH = process.env.HEAD || process.env.VERCEL_GIT_COMMIT_REF || "main";
const CLIENT_ID = String(process.env.TINA_CLIENT_ID ?? '');
const TOKEN = String(process.env.TINA_TOKEN ?? '');

export default defineConfig({
  branch: BRANCH,
  clientId: CLIENT_ID,
  token: TOKEN,
  client: { skip: true },
  build: {
    outputFolder: "admin",
    publicFolder: "",
  },
  media: {
    tina: {
      mediaRoot: "medias",
      publicFolder: "",
    },
  },
  schema: {
    collections: [
      {
        format: "md",
        label: "Formules",
        name: "formules",
        path: "_formulas",
        match: {
          include: "**/*",
        },
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
    ],
  },
});
