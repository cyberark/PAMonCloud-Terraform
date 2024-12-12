locals {
  rules = flatten([
    for component, rules in var.sg_rules : [
      for rule_name, rule in rules : {
        component = component
        rule_name = rule_name
        rule      = rule
      }
    ]
  ])
}


resource "aws_security_group_rule" "peering_rules" {
  for_each = {
    for rule in local.rules : rule.rule_name => rule
    if contains(keys(var.subnet_cidr_map), rule.rule[5])
  }

  type              = each.value.rule[0]
  from_port         = each.value.rule[1]
  to_port           = each.value.rule[2]
  protocol          = each.value.rule[3]
  description       = "${each.value.rule[4]}-peering"
  security_group_id = var.security_group_ids[each.value.component]

  cidr_blocks = [var.subnet_cidr_map[each.value.rule[5]]]

}