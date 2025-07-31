output "suppression_rules" {
  description = "Information about created suppression rules"
  value = merge(
    {
      for k, rule in stepsecurity_github_supression_rule.network_rules : k => {
        rule_id     = rule.rule_id
        name        = rule.name
        type        = rule.type
        action      = rule.action
        description = rule.description
        owner       = rule.owner
      }
    },
    {
      for k, rule in stepsecurity_github_supression_rule.file_rules : k => {
        rule_id     = rule.rule_id
        name        = rule.name
        type        = rule.type
        action      = rule.action
        description = rule.description
        owner       = rule.owner
      }
    }
  )
}

output "rule_ids" {
  description = "Map of rule names to their IDs"
  value = merge(
    {
      for k, rule in stepsecurity_github_supression_rule.network_rules : k => rule.rule_id
    },
    {
      for k, rule in stepsecurity_github_supression_rule.file_rules : k => rule.rule_id
    }
  )
}