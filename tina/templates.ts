import type { TinaField } from "tinacms";
export function postFields() {
  return [
    {
      type: "string",
      name: "layout",
      label: "Layout",
    },
    {
      type: "string",
      name: "title",
      label: "Titre",
      required: true,
    },
    {
      type: "string",
      name: "excerpt",
      label: "Extrait",
    },
    {
      type: "boolean",
      name: "set_permalink",
      label: "Personnaliser l'URL",
    },
    {
      type: "string",
      name: "permalink",
      label: "Permalien",
    },
    {
      type: "datetime",
      name: "date",
      label: "Date",
      required: true,
    },
    {
      type: "string",
      name: "author",
      label: "Auteur",
      required: true,
    },
    {
      type: "image",
      name: "image",
      label: "Image",
    },
    {
      type: "boolean",
      name: "show_image",
      label: "Afficher l'image",
    },
    {
      type: "string",
      name: "categories",
      label: "Catégories",
      list: true,
      ui: {
        component: "tags",
      },
    },
    {
      type: "string",
      name: "tags",
      label: "Tags",
      list: true,
      ui: {
        component: "tags",
      },
    },
  ] as TinaField[];
}
