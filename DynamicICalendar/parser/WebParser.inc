[ m W e b P a r s e r ]  
 M e a s u r e   =   P l u g i n  
 P l u g i n   =   W e b P a r s e r  
 U r l   =   # C a l 1 #  
 ; U r l   =   f i l e : / / D : \ D o c u m e n t s \ R a i n m e t e r \ S k i n s \ M i n i m a l \ D y n a m i c I C a l e n d a r \ p a r s e r \ m i n h . w o r k . i c s  
 D o w n l o a d   =   1  
 U p d a t e R a t e   =   # R e f r e s h R a t e #  
 D y n a m i c V a r i a b l e s   =   1  
 ; O n C h a n g e A c t i o n   =   [ ! C o m m a n d M e a s u r e   " m P a r s e r "   " c h e c k O n l i n e ( ) "   " # C U R R E N T C O N F I G # " ]  
 F i n i s h A c t i o n   =   [ ! C o m m a n d M e a s u r e   " m P a r s e r "   " p a r s e N e x t C a l e n d a r ( ) "   " # C U R R E N T C O N F I G # " ]  
  
 [ m P a r s e r ]  
 M e a s u r e   =   S c r i p t  
 S c r i p t F i l e   =   p a r s e r / p a r s e r . l u a  
 D i s a b l e d   =   1 