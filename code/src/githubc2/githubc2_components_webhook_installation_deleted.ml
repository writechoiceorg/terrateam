module Primary = struct
  module Action = struct
    let t_of_yojson = function
      | `String "deleted" -> Ok "deleted"
      | json -> Error ("Unknown value: " ^ Yojson.Safe.pretty_to_string json)

    type t = (string[@of_yojson t_of_yojson])
    [@@deriving yojson { strict = false; meta = true }, show, eq]
  end

  module Requester = struct
    type t = Yojson.Safe.t [@@deriving yojson { strict = false; meta = true }, show, eq]
  end

  type t = {
    action : Action.t;
    enterprise : Githubc2_components_enterprise_webhooks.t option; [@default None]
    installation : Githubc2_components_installation.t;
    organization : Githubc2_components_organization_simple_webhooks.t option; [@default None]
    repositories : Githubc2_components_webhooks_repositories.t option; [@default None]
    repository : Githubc2_components_repository_webhooks.t option; [@default None]
    requester : Requester.t option; [@default None]
    sender : Githubc2_components_simple_user.t;
  }
  [@@deriving yojson { strict = false; meta = true }, show, eq]
end

include Json_schema.Additional_properties.Make (Primary) (Json_schema.Obj)
