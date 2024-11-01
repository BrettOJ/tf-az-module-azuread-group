# tf-az-module-azuread-group
Terraform module to create a azure AD group


## Resource: azuread\_group

Manages a group within Azure Active Directory.

## [API Permissions](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#api-permissions)

The following API permissions are required in order to use this resource.

When authenticated with a service principal, this resource requires one of the following application roles: `Group.ReadWrite.All` or `Directory.ReadWrite.All`.

Alternatively, if the authenticated service principal is also an owner of the group being managed, this resource can use the application role: `Group.Create`.

If using the `assignable_to_role` property, this resource additionally requires the `RoleManagement.ReadWrite.Directory` application role.

If specifying owners for a group, which are user principals, this resource additionally requires one of the following application roles: `User.Read.All`, `User.ReadWrite.All`, `Directory.Read.All` or `Directory.ReadWrite.All`

When authenticated with a user principal, this resource requires one of the following directory roles: `Groups Administrator`, `User Administrator` or `Global Administrator`

When creating this resource in administrative units exclusively, the role `Groups Administrator` is required to be scoped on any administrative unit used.

The `external_senders_allowed`, `auto_subscribe_new_members`, `hide_from_address_lists` and `hide_from_outlook_clients` properties can only be configured when authenticating as a user and cannot be configured when authenticating as a service principal. Additionally, the user being used for authentication must be a Member of the tenant where the group is being managed and _not_ a Guest. This is a known API issue; please see the [Microsoft Graph Known Issues](https://docs.microsoft.com/en-us/graph/known-issues#groups) official documentation.

## [Example Usage](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#example-usage)

_Basic example_

```terraform
data "azuread_client_config" "current" {} resource "azuread_group" "example" { display_name = "example" owners = [data.azuread_client_config.current.object_id] security_enabled = true }
```

_Microsoft 365 group_

```terraform
data "azuread_client_config" "current" {} resource "azuread_user" "group_owner" { user_principal_name = "example-group-owner@hashicorp.com" display_name = "Group Owner" mail_nickname = "example-group-owner" password = "SecretP@sswd99!" } resource "azuread_group" "example" { display_name = "example" mail_enabled = true mail_nickname = "ExampleGroup" security_enabled = true types = ["Unified"] owners = [ data.azuread_client_config.current.object_id, azuread_user.group_owner.object_id, ] }
```

_Group with members_

```terraform
data "azuread_client_config" "current" {} resource "azuread_user" "example" { display_name = "J Doe" owners = [data.azuread_client_config.current.object_id] password = "notSecure123" user_principal_name = "jdoe@hashicorp.com" } resource "azuread_group" "example" { display_name = "MyGroup" owners = [data.azuread_client_config.current.object_id] security_enabled = true members = [ azuread_user.example.object_id, /* more users */ ] }
```

_Group with dynamic membership_

```terraform
data "azuread_client_config" "current" {} resource "azuread_group" "example" { display_name = "MyGroup" owners = [data.azuread_client_config.current.object_id] security_enabled = true types = ["DynamicMembership"] dynamic_membership { enabled = true rule = "user.department -eq \"Sales\"" } }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#argument-reference)

The following arguments are supported:

-   [`administrative_unit_ids`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#administrative_unit_ids) - (Optional) The object IDs of administrative units in which the group is a member. If specified, new groups will be created in the scope of the first administrative unit and added to the others. If empty, new groups will be created at the tenant level.

-   [`assignable_to_role`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#assignable_to_role) - (Optional) Indicates whether this group can be assigned to an Azure Active Directory role. Defaults to `false`. Can only be set to `true` for security-enabled groups. Changing this forces a new resource to be created.
-   [`auto_subscribe_new_members`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#auto_subscribe_new_members) - (Optional) Indicates whether new members added to the group will be auto-subscribed to receive email notifications. Can only be set for Unified groups.

-   [`behaviors`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#behaviors) - (Optional) A set of behaviors for a Microsoft 365 group. Possible values are `AllowOnlyMembersToPost`, `HideGroupInOutlook`, `SkipExchangeInstantOn`, `SubscribeMembersToCalendarEventsDisabled`, `SubscribeNewGroupMembers` and `WelcomeEmailDisabled`. See [official documentation](https://docs.microsoft.com/en-us/graph/group-set-options) for more details. Changing this forces a new resource to be created.
-   [`description`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#description) - (Optional) The description for the group.
-   [`display_name`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#display_name) - (Required) The display name for the group.
-   [`dynamic_membership`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#dynamic_membership) - (Optional) A `dynamic_membership` block as documented below. Required when `types` contains `DynamicMembership`. Cannot be used with the `members` property.
-   [`external_senders_allowed`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#external_senders_allowed) - (Optional) Indicates whether people external to the organization can send messages to the group. Can only be set for Unified groups.

-   [`hide_from_address_lists`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#hide_from_address_lists) - (Optional) Indicates whether the group is displayed in certain parts of the Outlook user interface: in the Address Book, in address lists for selecting message recipients, and in the Browse Groups dialog for searching groups. Can only be set for Unified groups.

-   [`hide_from_outlook_clients`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#hide_from_outlook_clients) - (Optional) Indicates whether the group is displayed in Outlook clients, such as Outlook for Windows and Outlook on the web. Can only be set for Unified groups.

-   [`mail_enabled`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#mail_enabled) - (Optional) Whether the group is a mail enabled, with a shared group mailbox. At least one of `mail_enabled` or `security_enabled` must be specified. Only Microsoft 365 groups can be mail enabled (see the `types` property).
-   [`mail_nickname`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#mail_nickname) - (Optional) The mail alias for the group, unique in the organisation. Required for mail-enabled groups. Changing this forces a new resource to be created.
-   [`members`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#members) - (Optional) A set of members who should be present in this group. Supported object types are Users, Groups or Service Principals. Cannot be used with the `dynamic_membership` block.

-   [`onpremises_group_type`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#onpremises_group_type) - (Optional) The on-premises group type that the AAD group will be written as, when writeback is enabled. Possible values are `UniversalDistributionGroup`, `UniversalMailEnabledSecurityGroup`, or `UniversalSecurityGroup`.
-   [`owners`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#owners) - (Optional) A set of object IDs of principals that will be granted ownership of the group. Supported object types are users or service principals. By default, the principal being used to execute Terraform is assigned as the sole owner. Groups cannot be created with no owners or have all their owners removed.

-   [`prevent_duplicate_names`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#prevent_duplicate_names) - (Optional) If `true`, will return an error if an existing group is found with the same name. Defaults to `false`.
-   [`provisioning_options`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#provisioning_options) - (Optional) A set of provisioning options for a Microsoft 365 group. The only supported value is `Team`. See [official documentation](https://docs.microsoft.com/en-us/graph/group-set-options) for details. Changing this forces a new resource to be created.
-   [`security_enabled`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#security_enabled) - (Optional) Whether the group is a security group for controlling access to in-app resources. At least one of `security_enabled` or `mail_enabled` must be specified. A Microsoft 365 group can be security enabled _and_ mail enabled (see the `types` property).
-   [`theme`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#theme) - (Optional) The colour theme for a Microsoft 365 group. Possible values are `Blue`, `Green`, `Orange`, `Pink`, `Purple`, `Red` or `Teal`. By default, no theme is set.
-   [`types`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#types) - (Optional) A set of group types to configure for the group. Supported values are `DynamicMembership`, which denotes a group with dynamic membership, and `Unified`, which specifies a Microsoft 365 group. Required when `mail_enabled` is true. Changing this forces a new resource to be created.

-   [`visibility`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#visibility) - (Optional) The group join policy and group content visibility. Possible values are `Private`, `Public`, or `Hiddenmembership`. Only Microsoft 365 groups can have `Hiddenmembership` visibility and this value must be set when the group is created. By default, security groups will receive `Private` visibility and Microsoft 365 groups will receive `Public` visibility.

-   [`writeback_enabled`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#writeback_enabled) - (Optional) Whether the group will be written back to the configured on-premises Active Directory when Azure AD Connect is used.

___

`dynamic_membership` block supports the following:

-   [`enabled`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#enabled) - (Required) Whether rule processing is "On" (true) or "Paused" (false).
-   [`rule`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#rule) - (Required) The rule that determines membership of this group. For more information, see official documentation on [membership rules syntax](https://docs.microsoft.com/en-gb/azure/active-directory/enterprise-users/groups-dynamic-membership).

## [Attributes Reference](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#attributes-reference)

In addition to all arguments above, the following attributes are exported:

-   [`mail`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#mail) - The SMTP address for the group.
-   [`object_id`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#object_id) - The object ID of the group.
-   [`onpremises_domain_name`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#onpremises_domain_name) - The on-premises FQDN, also called dnsDomainName, synchronised from the on-premises directory when Azure AD Connect is used.
-   [`onpremises_netbios_name`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#onpremises_netbios_name) - The on-premises NetBIOS name, synchronised from the on-premises directory when Azure AD Connect is used.
-   [`onpremises_sam_account_name`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#onpremises_sam_account_name) - The on-premises SAM account name, synchronised from the on-premises directory when Azure AD Connect is used.
-   [`onpremises_security_identifier`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#onpremises_security_identifier) - The on-premises security identifier (SID), synchronised from the on-premises directory when Azure AD Connect is used.
-   [`onpremises_sync_enabled`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#onpremises_sync_enabled) - Whether this group is synchronised from an on-premises directory (`true`), no longer synchronised (`false`), or has never been synchronised (`null`).
-   [`preferred_language`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#preferred_language) - The preferred language for a Microsoft 365 group, in ISO 639-1 notation.
-   [`proxy_addresses`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#proxy_addresses) - List of email addresses for the group that direct to the same group mailbox.

## [Timeouts](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#timeouts)

The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:

-   [`create`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#create) - (Defaults to 20 minutes) Used when creating the resource.
-   [`read`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#read) - (Defaults to 5 minutes) Used when retrieving the resource.
-   [`update`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#update) - (Defaults to 20 minutes) Used when updating the resource.
-   [`delete`](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#delete) - (Defaults to 5 minutes) Used when deleting the resource.

## [Import](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#import)

Groups can be imported using their object ID, e.g.

```shell
terraform import azuread_group.my_group 00000000-0000-0000-0000-000000000000
```