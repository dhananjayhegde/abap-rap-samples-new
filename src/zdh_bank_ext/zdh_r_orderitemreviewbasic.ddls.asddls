@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Item Review'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDH_R_OrderItemReviewBasic
  as select from zdh_t_ordritm_rv
{
  key order_id              as OrderId,
  key item_no               as ItemNo,
  key review_id             as ReviewId,
      rating                as Rating,
      free_text_comment     as FreeTextComment,
      helpful_count         as HelpfulCount,
      helpful_total         as HelpfulTotal,
      reviewer              as Reviewer,
      local_created_at      as LocalCreatedAt,
      local_last_changed_at as LocalLastChangedAt
}
