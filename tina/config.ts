import { defineConfig } from "tinacms";
import { postFields } from "./templates";

// Your hosting provider likely exposes this as an environment variable
const branch = process.env.HEAD || process.env.VERCEL_GIT_COMMIT_REF || "main";

export default defineConfig({
  branch,
  clientId: null, // Get this from tina.io
  token: null, // Get this from tina.io
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
