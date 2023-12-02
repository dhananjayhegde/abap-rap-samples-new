@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Item Attachment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDH_I_OrderItemAttachmentBasic
  as select from zdh_t_item_attch

  association [1..1] to ZDH_I_OrderBasic     as _Order     on  _Order.OrderId = $projection.OrderId

  association [1..1] to ZDH_I_OrderItemBasic as _OrderItem on  _OrderItem.OrderId = $projection.OrderId
                                                           and _OrderItem.ItemNo  = $projection.ItemNo
{
  key order_id              as OrderId,
  key item_no               as ItemNo,
  key seq_num               as SeqNum,
      attachment            as Attachment,
      mimetype              as MimeType,
      filename              as Filename,
      local_created_by      as LocalCreatedBy,
      local_created_at      as LocalCreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt,

      _Order,
      _OrderItem
}
