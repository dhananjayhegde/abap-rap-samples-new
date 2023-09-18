@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view for Order Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDH_I_OrderItemBasic
  as select from zdh_t_order_item
{
  key order_id               as OrderId,
  key item_no                as ItemNo,
      parent_item_no         as ParentItemNo,
      isoutline              as IsOutline,
      description            as Description,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      quantity               as Quantity,
      order_unit             as OrderUnit,
      @Semantics.amount.currencyCode: 'Currency'
      net_price              as NetPrice,
      currency               as Currency,
      status                 as Status,

      // Admin fields
      local_created_by       as LocalCreatedByUser,
      local_created_at       as LocalCreatedAt,
      local_last_changed_by  as LocalLastChangedByUser,
      local_last_changed_at  as LocalLastChangedAt,
      last_changed_at        as LastChangedAt
}
