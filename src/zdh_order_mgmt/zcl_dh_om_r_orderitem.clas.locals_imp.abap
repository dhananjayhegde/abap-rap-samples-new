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
    METHODS ValidateAction FOR MODIFY
      IMPORTING keys FOR ACTION OrderItems~ValidateAction.

ENDCLASS.

CLASS lhc_OrderItems IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CancelOrder.
    IF lines( keys ) = 3.
      " No errors in case of only 1 item selection
      RETURN.
    ELSEIF lines( keys ) = 2.
      reported-orderitems = VALUE #( FOR <key> IN keys
                                     ( %cid = <key>-%cid_ref
                                       %tky = <key>-%tky
                                       %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                                                     text     = `Sample warning from Cancel!` ) ) ).
    ELSE.
      reported-orderitems = VALUE #( FOR <key> IN keys
                                     ( %cid = <key>-%cid_ref
                                       %tky = <key>-%tky
                                       %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                     text     = `Sample error from Cancel!` ) ) ).
      failed-orderitems = CORRESPONDING #( keys ).

    ENDIF.
  ENDMETHOD.

  METHOD precheck_CancelOrder.
    IF lines( keys ) = 3.
      " No errors in case of only 1 item selection
      RETURN.
    ELSEIF lines( keys ) = 2.
      reported-orderitems = VALUE #(
          FOR <key> IN keys
          ( %cid = <key>-%cid_ref
            %tky = <key>-%tky
            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                          text     = `Sample warning from Precheck Cancel!` ) ) ).
    ELSE.
      reported-orderitems = VALUE #( FOR <key> IN keys
                                     ( %cid = <key>-%cid_ref
                                       %tky = <key>-%tky
                                       %msg = new_message_with_text(
                                                  severity = if_abap_behv_message=>severity-error
                                                  text     = `Sample error from Precheck Cancel!` ) ) ).
      failed-orderitems = CORRESPONDING #( keys ).

    ENDIF.
  ENDMETHOD.

  METHOD KeepOrder.
  ENDMETHOD.

  METHOD precheck_KeepOrder.
  ENDMETHOD.

  METHOD RescheduleDelivery.
  ENDMETHOD.

  METHOD precheck_RescheduleDelivery.
  ENDMETHOD.

  METHOD ValidateAction.
    IF lines( keys ) = 3.
      " No errors in case of only 1 item selection
      RETURN.
    ELSEIF lines( keys ) = 2.
*      reported-orderitems = VALUE #(
*          FOR <key> IN keys
*          ( %cid = <key>-%cid_ref
*            %tky = <key>-%tky
*            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
*                                          text     = `Sample warning from Validate Action!` ) ) ).
    ELSE.
      reported-orderitems = VALUE #( FOR <key> IN keys
                                     ( %cid = <key>-%cid_ref
                                       %tky = <key>-%tky
                                       %msg = new_message_with_text(
                                                  severity = if_abap_behv_message=>severity-error
                                                  text     = `Sample error from Validate Action!` ) ) ).
      failed-orderitems = CORRESPONDING #( keys ).

    ENDIF.
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
