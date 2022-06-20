*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 24.03.2022 at 17:41:08
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZUBME_T008......................................*
DATA:  BEGIN OF STATUS_ZUBME_T008                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZUBME_T008                    .
CONTROLS: TCTRL_ZUBME_T008
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZUBME_T008                    .
TABLES: ZUBME_T008                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
