l o c a l   F i l e R e a d e r   d o  
 	 - -   @ p a r a m   f i l e N a m e   s t r i n g  
 	 - -   @ r e t u r n   c o n t e n t   s t r i n g  
 	 f u n c t i o n   F i l e R e a d e r ( f i l e N a m e )  
 	 	 i f   n o t   f i l e N a m e   t h e n    
 	 	 	 p r i n t ( " I l l e g a l A r g u m e n t E X c e p t i o n :   "   . .   f i l e N a m e   . .   "   n o t   a   v a l i d   n a m e . " )  
 	 	 	 r e t u r n   " "    
 	 	 e n d  
  
 	 	 l o c a l   f i l e H a n d l e   =   i o . o p e n ( f i l e N a m e )  
 	 	 i f   f i l e H a n d l e   = =   n i l   t h e n  
 	 	 	 i o . c l o s e ( f i l e H a n d l e )  
 	 	 	 p r i n t ( " I O E X c e p t i o n :   "   . .   f i l e P a t h   . .   "   n o t   f o u n d . " )  
 	 	 	 r e t u r n   " "  
 	 	 e l s e    
 	 	 	 l o c a l   c o n t e n t   =   f i l e H a n d l e : r e a d ( ' * a l l ' )  
 	 	 	 i o . c l o s e ( f i l e H a n d l e )  
  
 	 	 	 r e t u r n   c o n t e n t  
 	 	 e n d  
 	 e n d  
 e n d  
  
 r e t u r n   F i l e R e a d e r 