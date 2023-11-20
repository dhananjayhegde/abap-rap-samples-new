@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hierarchy Node For Order Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDH_I_OrderItemNode
  as select from ZDH_I_OrderItemBasic

  association to ZDH_I_OrderItemNode as _Parent on  $projection.OrderId      = _Parent.OrderId
                                                and $projection.ParentItemNo = _Parent.ItemNo
{
  key OrderId,
  key ItemNo,
      ParentItemNo,
      Description,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      Quantity,
      OrderUnit,
      @Semantics.amount.currencyCode: 'Currency'
      NetPrice,
      Currency,
      Status,
      
      LocalLastChangedByUser,
      LastChangedAt,
      
      _Parent
}
