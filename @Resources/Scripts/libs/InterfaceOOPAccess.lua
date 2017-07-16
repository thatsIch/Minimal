r e t u r n   f u n c t i o n ( S K I N )  
 	 l o c a l   m s   =   {  
 	 	 _ _ i n d e x   =   f u n c t i o n ( t a b l e , k e y )    
 	 	  
 	 	 	 - -   c a t c h   i s M e t e r ( )  
 	 	 	 i f   k e y   = =   ' i s M e t e r '   t h e n  
 	 	 	 	 r e t u r n   f u n c t i o n ( )   r e t u r n   S K I N : G e t M e t e r ( t a b l e . _ _ s e c t i o n n a m e )   a n d   t r u e   o r   f a l s e   e n d  
  
 	 	 	 - -   c a t c h   i s M e t e r ( )  
 	 	 	 e l s e i f   k e y   = =   ' i s M e a s u r e '   t h e n  
 	 	 	 	 r e t u r n   f u n c t i o n ( )   r e t u r n   S K I N : G e t M e a s u r e ( t a b l e . _ _ s e c t i o n n a m e )   a n d   t r u e   o r   f a l s e   e n d  
  
 	 	 	 - -   c a t c h   r e c u r s i v e   c a l l 	 	  
 	 	 	 e l s e i f   k e y   = =   ' _ _ s e c t i o n '   t h e n  
 	 	 	 	 r e t u r n   f a l s e  
  
 	 	 	 e l s e i f   k e y   = =   ' _ _ s e c t i o n n a m e '   t h e n  
 	 	 	 	 r e t u r n   f a l s e  
  
 	 	 	 - -   c a t c h   M e a s u r e . u p d a t e ( )  
 	 	 	 e l s e i f   k e y   = =   ' u p d a t e '   a n d   t a b l e . _ _ s e c t i o n n a m e   a n d   S K I N : G e t M e a s u r e ( t a b l e . _ _ s e c t i o n n a m e )   t h e n    
 	 	 	 	 r e t u r n   f u n c t i o n ( )   S K I N : B a n g ( ' ! U p d a t e M e a s u r e ' , t a b l e . _ _ s e c t i o n n a m e ,   S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )   e n d    
  
 	 	 	 - -   c a t c h   M e a s u r e . f o r c e U p d a t e ( )  
 	 	 	 e l s e i f   k e y   = =   ' f o r c e U p d a t e '   a n d   t a b l e . _ _ s e c t i o n n a m e   a n d   S K I N : G e t M e a s u r e ( t a b l e . _ _ s e c t i o n n a m e )   t h e n    
 	 	 	 	 r e t u r n   f u n c t i o n ( )   S K I N : B a n g ( ' ! C o m m a n d M e a s u r e ' , t a b l e . _ _ s e c t i o n n a m e ,   ' U p d a t e ' ,   S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )   e n d    
  
 	 	 	 - -   c a t c h   M e t e r s . u p d a t e ( ) 	  
 	 	 	 e l s e i f   k e y   = =   ' u p d a t e '   a n d   t a b l e . _ _ s e c t i o n n a m e   a n d   S K I N : G e t M e t e r ( t a b l e . _ _ s e c t i o n n a m e )   t h e n    
 	 	 	 	 r e t u r n   f u n c t i o n ( )   S K I N : B a n g ( ' ! U p d a t e M e t e r ' , t a b l e . _ _ s e c t i o n n a m e ,   S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )   e n d    
  
 	 	 	 - -   c a t c h   h i d e ( )  
 	 	 	 e l s e i f   k e y   = =   ' h i d e '   a n d   S K I N : G e t M e t e r ( t a b l e . _ _ s e c t i o n n a m e )   t h e n  
 	 	 	 	 r e t u r n   f u n c t i o n ( )   S K I N : B a n g ( ' ! H i d e M e t e r ' , t a b l e . _ _ s e c t i o n n a m e ,   S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )   e n d  
  
 	 	 	 - -   c a t c h   s h o w ( )  
 	 	 	 e l s e i f   k e y   = =   ' s h o w '   a n d   S K I N : G e t M e t e r ( t a b l e . _ _ s e c t i o n n a m e )   t h e n  
 	 	 	 	 r e t u r n   f u n c t i o n ( )   S K I N : B a n g ( ' ! S h o w M e t e r ' , t a b l e . _ _ s e c t i o n n a m e ,   S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )   e n d  
  
 	 	 	 - -   c a t c h   X  
 	 	 	 e l s e i f   k e y   = =   ' X '   a n d   S K I N : G e t M e t e r ( t a b l e . _ _ s e c t i o n n a m e )   t h e n  
 	 	 	 	 r e t u r n   S K I N : G e t M e t e r ( t a b l e . _ _ s e c t i o n n a m e ) : G e t X ( )  
  
 	 	 	 e l s e i f   k e y   = =   ' Y '   a n d   S K I N : G e t M e t e r ( t a b l e . _ _ s e c t i o n n a m e )   t h e n  
 	 	 	 	 r e t u r n   S K I N : G e t M e t e r ( t a b l e . _ _ s e c t i o n n a m e ) : G e t Y ( )  
  
 	 	 	 - -   c a t c h   R a i n m e t e r   N a t i v e   B u i l d - I n   f u n c t i o n s  
 	 	 	 - -   S h o w ,   H i d e ,   S e t X Y W H ,   G e t X Y W H ,   G e t N a m e ,   G e t O p t i o n   ( t h o u g h   s p e c i a l   c a s e ) ,   E n a b l e ,   D i s a b l e ,   G e t V a l u e R a n g e ,   G e t R e l a t i v e V a l u e ,   G e t M a x V a l u e ,    
 	 	 	 e l s e i f   t a b l e . _ _ s e c t i o n   a n d   t a b l e . _ _ s e c t i o n [ k e y ]   t h e n    
 	 	 	 	 r e t u r n   f u n c t i o n ( . . . )   r e t u r n   t a b l e . _ _ s e c t i o n [ k e y ] ( t a b l e . _ _ s e c t i o n , . . . )   e n d    
 	 	 	  
 	 	 	 - -   c a t c h   m e t e r   o p t i o n s  
 	 	 	 e l s e i f   t a b l e . _ _ s e c t i o n   a n d   t a b l e . _ _ s e c t i o n . G e t O p t i o n   t h e n  
 	 	 	 	 r e t u r n   t a b l e . _ _ s e c t i o n : G e t O p t i o n ( k e y )  
  
 	 	 	 - -   c a t c h   m e a s u r e   o p t i o n s  
 	 	 	 e l s e i f   t a b l e . _ _ s e c t i o n   a n d   t a b l e . _ _ s e c t i o n . G e t N u m b e r O p t i o n   t h e n  
 	 	 	 	 r e t u r n   ( t a b l e . _ _ s e c t i o n . G e t N u m b e r O p t i o n   a n d   t a b l e . _ _ s e c t i o n : G e t N u m b e r O p t i o n ( k e y , n i l ) )  
 	 	 	  
 	 	 	 - -   u n k n o w n   c a s e  
 	 	 	 e l s e  
 	 	 	 	 p r i n t ( ' N a m e :   '   . .   t a b l e . _ _ s e c t i o n n a m e   . .   ' ,   k e y :   '   . .   k e y )    
 	 	 	 	 r e t u r n   n i l  
 	 	 	 e n d    
 	 	 e n d ,    
 	 	 _ _ n e w i n d e x   =   f u n c t i o n ( t a b l e , k e y , v a l u e )   S K I N : B a n g ( ' ! S e t O p t i o n ' , t a b l e . _ _ s e c t i o n n a m e , k e y , v a l u e , S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )   e n d  
 	 }  
 	 s e c t i o n s   =   {  
 	 	 _ _ i n d e x   =   f u n c t i o n ( t a b l e , k e y )    
 	 	 	 i f   k e y   = =   ' r e d r a w '   t h e n  
 	 	 	 	 r e t u r n   f u n c t i o n ( )   S K I N : B a n g ( ' ! R e d r a w ' ,   S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )   e n d  
 	 	 	 e l s e  
 	 	 	 	 s e c t i o n s [ k e y ]   =   { }  
  
 	 	 	 	 - -   s t o r e   m e t e r / m e a s u r e  
 	 	 	 	 s e c t i o n s [ k e y ] . _ _ s e c t i o n   =   S K I N : G e t M e a s u r e ( k e y )   o r   S K I N : G e t M e t e r ( k e y )   o r   f a l s e  
 	 	 	 	  
 	 	 	 	 - -   s t o r e   m e t e r / m e a s u r e n a m e  
 	 	 	 	 s e c t i o n s [ k e y ] . _ _ s e c t i o n n a m e   =   k e y    
 	 	 	 	 s e t m e t a t a b l e ( s e c t i o n s [ k e y ] , m s )  
  
 	 	 	 	 r e t u r n   s e c t i o n s [ k e y ]  
 	 	 	 e n d  
 	 	 e n d ,  
 	 	 i s M e t e r   =   f u n c t i o n ( m e t e r )  
 	 	 	 r e t u r n   S K I N : G e t M e t e r ( m e t e r )   a n d   t r u e   o r   f a l s e  
 	 	 e n d ,  
 	 	 i s M e a s u r e   =   f u n c t i o n ( m e a s u r e )  
 	 	 	 r e t u r n   S K I N : G e t M e a s u r e ( m e a s u r e )   a n d   t r u e   o r   f a l s e  
 	 	 e n d ,  
 	 	 t o g g l e G r o u p   =   f u n c t i o n ( m e t e r G r o u p )  
 	 	 	 S K I N : B a n g ( ' ! T o g g l e M e t e r G r o u p ' ,   m e t e r G r o u p , S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )  
 	 	 e n d  
 	 }  
 	 l o c a l   v a r i a b l e s   =   {  
 	 	 _ _ i n d e x   =   f u n c t i o n ( t a b l e , k e y )    
  
 	 	 	 - -   c a t c h   v a r i a b l e s . R e p l a c e V a r i a b l e s ( )  
 	 	 	 i f   k e y   = =   ' R e p l a c e V a r i a b l e s '   t h e n  
 	 	 	 	 r e t u r n   f u n c t i o n ( p a r a m )   r e t u r n   S K I N : R e p l a c e V a r i a b l e s ( p a r a m )   e n d  
  
 	 	 	 - -   c a t c h   v a r i a b l e 	 	 	  
 	 	 	 e l s e i f   S K I N : G e t V a r i a b l e ( k e y )   t h e n  
 	 	 	 	 r e t u r n   S K I N : G e t V a r i a b l e ( k e y )    
  
 	 	 	 - -   u n k n o w n   c a s e  
 	 	 	 e l s e    
 	 	 	 	 - -   p r i n t ( ' U n k o w n   V a r i a b l e   C a s e :   '   . .   k e y )  
 	 	 	 	 r e t u r n   n i l  
 	 	 	 e n d  
 	 	 e n d ,    
 	 	 _ _ n e w i n d e x   =   f u n c t i o n ( t a b l e , k e y , v a l u e )   S K I N : B a n g ( ' ! S e t V a r i a b l e ' , k e y , v a l u e ,   S K I N : G e t V a r i a b l e ( ' C U R R E N T C O N F I G ' ) )   e n d  
 	 }  
 	 s e t m e t a t a b l e ( v a r i a b l e s , v a r i a b l e s )  
 	 s e t m e t a t a b l e ( s e c t i o n s , s e c t i o n s )  
  
 	 r e t u r n   s e c t i o n s ,   s e c t i o n s ,   v a r i a b l e s  
 e n d 