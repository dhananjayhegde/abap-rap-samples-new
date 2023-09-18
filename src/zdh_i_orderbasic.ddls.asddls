@EndUserText.label: 'Basic CDS view for Order Header'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDH_I_OrderBasic
  as select from zdh_t_order
{
  key order_id               as OrderId,
      description            as Description,
      @Semantics.amount.currencyCode: 'currency'
      total_amount           as TotalAmount,
      currency               as Currency,
      status                 as Status,

      // Admin fields
      local_created_by       as LocalCreatedByUser,
      local_created_at       as LocalCreatedAt,
      local_last_changed_by  as LocalLastChangedByUser,
      local_last_changed_at  as LocalLastChangedAt,
      last_changed_at        as LastChangedAt
}
