@EndUserText.label: 'Order Item Hierarchy'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define hierarchy ZDH_I_OrderItemHierarchyDir
  with parameters
    p_order_id : ebeln
  as parent child hierarchy(
    source ZDH_I_OrderItemNode_2
    child to parent association _Parent
    directory _OrderHeader filter by
      OrderId = $parameters.p_order_id
    start where
      ParentItemNo is initial
    siblings order by
      ItemNo
    multiple parents not allowed
  )
{
  key OrderId,
  key ItemNo,
      ParentItemNo
}
