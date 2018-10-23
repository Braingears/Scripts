$node = Get-ClusterNode | Select-Object Name | Out-GridView -Title "Select one or more Nodes  to drain" -PassThru
Suspend-ClusterNode -Name $node.Name -Drain
#restart $node.Name
Resume-ClusterNode -Name $node.Name -Failback Immediate