*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 23.02.2022 at 15:35:58
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZUBME_V007......................................*
TABLES: ZUBME_V007, *ZUBME_V007. "view work areas
CONTROLS: TCTRL_ZUBME_V007
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZUBME_V007. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZUBME_V007.
* Table for entries selected to show on screen
DATA: BEGIN OF ZUBME_V007_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZUBME_V007.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZUBME_V007_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZUBME_V007_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZUBME_V007.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZUBME_V007_TOTAL.

*.........table declarations:.................................*
TABLES: ZUBME_T007                     .
