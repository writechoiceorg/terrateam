module Primary = struct
  module Action = struct
    let t_of_yojson = function
      | `String "archived" -> Ok "archived"
      | json -> Error ("Unknown value: " ^ Yojson.Safe.pretty_to_string json)

    type t = (string[@of_yojson t_of_yojson])
    [@@deriving yojson { strict = false; meta = true }, show, eq]
  end

  type t = {
    action : Action.t;
    changes : Githubc2_components_webhooks_project_changes.t;
    installation : Githubc2_components_simple_installation.t option; [@default None]
    organization : Githubc2_components_organization_simple_webhooks.t;
    projects_v2_item : Githubc2_components_projects_v2_item.t;
    sender : Githubc2_components_simple_user.t;
  }
  [@@deriving yojson { strict = false; meta = true }, show, eq]
end

include Json_schema.Additional_properties.Make (Primary) (Json_schema.Obj)
