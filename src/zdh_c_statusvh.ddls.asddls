@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain Value list for Status field'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

// To show value help as a drop down
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZDH_C_StatusVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T ( p_domain_name: 'ZDH_D_STATUS' )
{

      @ObjectModel.text.element: [ 'StatusText' ]
  key value_low as Status,
  key language  as Language,
      @Semantics.text: true
      text      as StatusText
}
