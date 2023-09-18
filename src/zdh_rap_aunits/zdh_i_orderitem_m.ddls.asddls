@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS view for Order Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDH_I_OrderItem_M
  as select from ZDH_I_OrderItemBasic

  association to parent ZDH_I_OrderHeader_M as _Order on $projection.OrderId = _Order.OrderId
{
  key OrderId,
  key ItemNo,

      ItemNo as ItemNoForEdit,
      ParentItemNo,
      
      IsOutline,
      Description,
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      Quantity,
      OrderUnit,

      @Semantics.amount.currencyCode: 'Currency'
      NetPrice,
      Currency,
      Status,
      
      @Semantics.largeObject:{
        mimeType: 'MimeType',
        fileName: 'FileName',
        contentDispositionPreference: #ATTACHMENT
      }
      Attachment,
      MimeType,
      FileName,

      //Admin fields
      @Semantics.user.createdBy: true
      LocalCreatedByUser,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      LocalLastChangedByUser,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,

      _Order
}
