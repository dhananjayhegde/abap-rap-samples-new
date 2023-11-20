@EndUserText.label: 'Order Item Hierarchy'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define hierarchy ZDH_I_OrderItemHierarchy
  as parent child hierarchy(
    source ZDH_I_OrderItemNode
    child to parent association _Parent
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
