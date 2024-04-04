CLASS lhc_OrderItems DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR OrderItems RESULT result.

    METHODS CancelOrder FOR MODIFY
      IMPORTING keys FOR ACTION OrderItems~CancelOrder.

    METHODS precheck_CancelOrder FOR PRECHECK
      IMPORTING keys FOR ACTION OrderItems~CancelOrder.

    METHODS KeepOrder FOR MODIFY
      IMPORTING keys FOR ACTION OrderItems~KeepOrder.

    METHODS precheck_KeepOrder FOR PRECHECK
      IMPORTING keys FOR ACTION OrderItems~KeepOrder.

    METHODS RescheduleDelivery FOR MODIFY
      IMPORTING keys FOR ACTION OrderItems~RescheduleDelivery.

    METHODS precheck_RescheduleDelivery FOR PRECHECK
      IMPORTING keys FOR ACTION OrderItems~RescheduleDelivery.

ENDCLASS.

CLASS lhc_OrderItems IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CancelOrder.
  ENDMETHOD.

  METHOD precheck_CancelOrder.
  ENDMETHOD.

  METHOD KeepOrder.
  ENDMETHOD.

  METHOD precheck_KeepOrder.
  ENDMETHOD.

  METHOD RescheduleDelivery.
  ENDMETHOD.

  METHOD precheck_RescheduleDelivery.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZDH_OM_R_ORDERITEM DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZDH_OM_R_ORDERITEM IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
