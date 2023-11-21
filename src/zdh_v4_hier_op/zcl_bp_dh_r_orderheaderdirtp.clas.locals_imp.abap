CLASS lhc_OrderHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR OrderHeader RESULT result.

ENDCLASS.

CLASS lhc_OrderHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_OrderItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR OrderItem RESULT result.

    METHODS SetToComplete FOR MODIFY
      IMPORTING keys FOR ACTION OrderItem~SetToComplete.

ENDCLASS.

CLASS lhc_OrderItem IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD SetToComplete.
  ENDMETHOD.

ENDCLASS.
