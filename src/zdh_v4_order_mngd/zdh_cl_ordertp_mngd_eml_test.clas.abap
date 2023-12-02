CLASS zdh_cl_ordertp_mngd_eml_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zdh_cl_ordertp_mngd_eml_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    MODIFY ENTITIES OF ZDH_R_OrderHeaderMngdTP
        ENTITY Order
            CREATE SET FIELDS WITH VALUE #( ( %cid          = 'order_1'
                                              OrderId       = '4500001000'
                                              Description   = `Test Order`
                                              Currency      = 'EUR'
                                              TotalAmount   = 120000
                                              Status        = '' ) )
            CREATE BY \_Item SET FIELDS WITH VALUE #( ( %cid_ref = 'order_1'
                                                        %target = VALUE #( (  %cid          = 'item_1'
                                                                              itemNo        = '00010'
                                                                              ParentItemNo  = '00000'
                                                                              Description   = `Test Order`
                                                                              Quantity      = 100
                                                                              OrderUnit     = 'EA'
                                                                              NetPrice      = 255
                                                                              Currency      = 'EUR'
                                                                              Status        = '02' )
                                                                           (  %cid          = 'item_2'
                                                                              itemNo        = '00020'
                                                                              ParentItemNo  = '00010'
                                                                              Description   = `Test Order`
                                                                              Quantity      = 500
                                                                              OrderUnit     = 'EA'
                                                                              NetPrice      = 100
                                                                              Currency      = 'EUR'
                                                                              Status        = '02' )
                                                                           (  %cid          = 'item_3'
                                                                              itemNo        = '00030'
                                                                              ParentItemNo  = '00000'
                                                                              Description   = `Test Order`
                                                                              Quantity      = 999
                                                                              OrderUnit     = 'EA'
                                                                              NetPrice      = 25
                                                                              Currency      = 'EUR'
                                                                              Status        = '02' )
                                                                           (  %cid          = 'item_4'
                                                                              itemNo        = '00040'
                                                                              ParentItemNo  = '00030'
                                                                              Description   = `Test Order`
                                                                              Quantity      = 800
                                                                              OrderUnit     = 'EA'
                                                                              NetPrice      = 30
                                                                              Currency      = 'EUR'
                                                                              Status        = '02' ) ) ) )
        FAILED DATA(ls_failed)
        REPORTED DATA(ls_reported)
        MAPPED DATA(ls_mapped).


    IF ls_failed IS INITIAL.
      COMMIT ENTITIES RESPONSE OF ZDH_R_OrderHeaderMngdTP REPORTED DATA(ls_save_reported) FAILED DATA(ls_save_failed).

      out->write( ls_save_failed-item ).
      out->write( ls_save_reported-item ).
    ELSE.
      out->write( ls_failed-item ).
      out->write( ls_reported-item ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
