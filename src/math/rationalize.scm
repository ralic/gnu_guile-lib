;;; ----------------------------------------------------------------------
;;;    rationalize -- finding simple ratios near arbitrary numbers
;;;    Copyright (C) ???????
;;;
;;;    This program is free software; you can redistribute it and/or modify
;;;    it under the terms of the GNU General Public License as published by
;;;    the Free Software Foundation; either version 2 of the License, or
;;;    (at your option) any later version.
;;;
;;;    This program is distributed in the hope that it will be useful,
;;;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;    GNU General Public License for more details.
;;;
;;;    You should have received a copy of the GNU General Public License
;;;    along with this program; if not, write to the Free Software
;;;    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;;; ----------------------------------------------------------------------
;; Original SLIB code has no (c) information...

;;; Commentary:
;; Functions for rationalizing numbers, and finding simple ratios.
;;; Code:

(define-module (math rationalize)
  #:export (rationalize
            find-ratio))

;;The procedure @dfn{rationalize} is interesting because most programming
;;languages do not provide anything analogous to it.  Thanks to Alan
;;Bawden for contributing this algorithm.

;;@body

(define (rationalize x e) 
"Returns an exact number that is within @var{e} of @var{x}.  
Computes the correct result for exact arguments (provided the
implementation supports exact rational numbers of unlimited precision);
and produces a reasonable answer for inexact arguments when inexact
arithmetic is implemented using floating-point."
  (apply / (find-ratio x e)))

;;@code{Rationalize} has limited use in implementations lacking exact
;;(non-integer) rational numbers.  The following procedures return a list
;;of the numerator and denominator.

(define (find-ratio x e) 
"Returns the list of the @emph{simplest} numerator and
denominator whose quotient differs from @var{x} by no more than @var{e}.

@example
 (find-ratio 3/97 .0001)  @result{} (3 97)
 (find-ratio 3/97 .001)   @result{} (1 32)
@end example"
(find-ratio-between (- x e) (+ x e)))


;;@body
;;@0 returns the list of the @emph{simplest}
;;numerator and denominator between @1 and @2.
;;
;;@format
;;@t{(find-ratio-between 2/7 3/5)        @result{} (1 2)
;;(find-ratio-between -3/5 -2/7)      @result{} (-1 2)
;;}
;;@end format
(define (find-ratio-between x y)
  (define (sr x y)
    (let ((fx (inexact->exact (floor x))) (fy (inexact->exact (floor y))))
      (cond ((>= fx x) (list fx 1))
	    ((= fx fy) (let ((rat (sr (/ (- y fy)) (/ (- x fx)))))
			 (list (+ (cadr rat) (* fx (car rat))) (car rat))))
	    (else (list (+ 1 fx) 1)))))
  (cond ((< y x) (find-ratio-between y x))
	((>= x y) (list x 1))
	((positive? x) (sr x y))
	((negative? y) (let ((rat (sr (- y) (- x))))
			 (list (- (car rat)) (cadr rat))))
	(else '(0 1))))

;;; arch-tag: 58594c73-bca4-4554-9f28-40a561aa8f15
