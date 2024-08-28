@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Item Review'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDH_R_OrderItemReviewTP
  as select from ZDH_R_OrderItemReviewBasic

  association to parent ZDH_OM_R_OrderItem as _OrderItem on  $projection.OrderId = _OrderItem.OrderId
                                                         and $projection.ItemNo  = _OrderItem.ItemNo
{
  key OrderId,
  key ItemNo,
  key ReviewId,
      Rating,
      FreeTextComment,
      HelpfulCount,
      HelpfulTotal,
      Reviewer,
      LocalCreatedAt,
      LocalLastChangedAt,

      /* Associations */
      _OrderItem
}
