;;;Frameworks location:
(setf Frameworks-directory  (append (butlast (pathname-directory *load-pathname*)) '("Frameworks")))

;;;;;;;;;;;;;;;;;;
;; VPS-Constraints
;;;;;;;;;;;;;;;;;;
(setf VPS-constraints-path (make-pathname :directory Frameworks-directory :name "stroppa-constraints.framework/Versions/A/stroppa-constraints"))

;version dev:
;(fli:register-module "vps-constraints" :real-name "/Users/lemouton/Projets/Contraintes/Gecode/SLM-Models/stroppa/build/Release/stroppa-constraints.framework/Versions/A/stroppa-constraints" :connection-style :immediate)


;; load the framework

(fli:register-module "vps-constraints" :real-name VPS-constraints-path :connection-style :immediate)

;; interfaces to C function
(fli:define-foreign-function (gvpsC "gVpsG" :source)
    ((n :int)
     (a :int)
     (b :int)
     (density :pointer)
     (cs :pointer)
     (domain :pointer)
     (nsol :int)
     (time :int)
     (string2 :pointer))
  :language :c
  :calling-convention :cdecl)


(defun c-vpsG (n a b  solutions
 &KEY (density "(0 0)") (cs "(0 0)") (domain "(0)") (timelimit 0))
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 2506)
               :initial-element "Lisp String1")
       (c-string2 (:ef-mb-string :limit 2506)
               :initial-element "Lisp String1")
       (c-string3 (:ef-mb-string :limit 2506)
               :initial-element "Lisp String1")
       (result-string (:ef-mb-string :limit 81902)
              :initial-element "Lisp String2"))
   (let(
        (c-string1 (fli::convert-to-dynamic-foreign-string density))
        (c-string2 (fli::convert-to-dynamic-foreign-string cs))
        (c-string3 (fli::convert-to-dynamic-foreign-string domain))
        )
     (gvpsC n a b c-string1 c-string2 c-string3 solutions timelimit result-string )
     (fli:convert-from-foreign-string result-string))))

;(c-vpsG 5 60 0 4 :density "(0.3 0.4)")
;(c-vpsG 5 60 0 7 :cs "(0.5 0.6)")
;(c-vpsG 5 60 0 7 :density "(0.0 1.)")
;(c-vpsG 5 60 0 7 :density "(0. 2.)" :cs "(0.5 0.6)")

;;cs weights :

;(setf wl (loop for i from 0 to 128 collect (cr::get-weight i cr::*STABILITY-SPACE*)))
; (setq wlstr (make-array '(0) :element-type 'base-char :fill-pointer 0 :adjustable t))
;(with-output-to-string (s wlstr)
;  (loop for i from 0 to 128 do (format s "~D, " (round(*(nth i wl) 100)))))
;wlstr

;;;;;;;;;;;;;;;;;;
;; Chord sorting
;;;;;;;;;;;;;;;;;;

(setf chsort-path (make-pathname :directory Frameworks-directory :name "chsort-constraints.framework/Versions/A/chsort-constraints"))
(fli:register-module "chsort-constraints" :real-name chsort-path)

;; interfaces to C function
(fli:define-foreign-function (chsortC "chsortG" :source)
    ((n :int)
     (string1 :pointer)
     (i1 :int)
     (i2 :int)
     (i3 :int)
     (string2 :pointer))
  :language :c
  :calling-convention :cdecl)


(defun c-chsort (n str solutions
 &KEY (timelimit 0)(model 0))
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 10000)
               :initial-element "Lisp String1")
       (result-string (:ef-mb-string :limit 819020)
              :initial-element "Lisp String2"))
   (let(
         (c-string1 (fli::convert-to-dynamic-foreign-string str))
           )
       (chsortC n  c-string1 solutions timelimit model result-string )
     (fli:convert-from-foreign-string result-string))))


;(c-chsort 4 "((60 61 62)(61 62)(62 63)(60 61))" 1)
;(c-chsort 5 "((60 61 62)(61 62)(62 63)(60 61)(60 63))" 12)

;;;;;;;;;;;;;;;;;;
;; ALL-INTERVALS
;;;;;;;;;;;;;;;;;;
(setf All-interval-path (make-pathname :directory Frameworks-directory :name "all-interval-constraints.framework/Versions/A/all-interval-constraints"))

;; load the frameworks (one per model)
;(fli:register-module "all-interval-constraints" :real-name "/Users/lemouton/Library/Frameworks/all-interval-constraints.framework/Versions/A/all-interval-constraints" )
;version dev:
;(fli:register-module "all-interval-constraints" :real-name "/Users/lemouton/Projets/Contraintes/Gecode/C++\ Examples.3.2/SLM-Models/all-interval/build/Release/all-interval-constraints.framework/Versions/A/all-interval-constraints" :connection-style :immediate)

(fli:register-module "all-interval-constraints" :real-name All-interval-path)


;; interfaces to C function
(fli:define-foreign-function (allintervalC "allintervalG" :source)
    ((n :int)
     (i1 :int)
     (string1 :pointer)
     (i2 :int)
     (i3 :int)
     (i4 :int)
     (i5 :int)
     (string2 :pointer))
  :language :c
  :calling-convention :cdecl)


(defun c-allintervalG (n solutions
 &KEY (timelimit 0)(model 0)(symmetry 0))
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 2506)
               :initial-element "Lisp String1")
       (result-string (:ef-mb-string :limit 819020)
              :initial-element "Lisp String2"))
   (let(
         (c-string1 (fli::convert-to-dynamic-foreign-string "one"))
           )
       (allintervalC n solutions c-string1 timelimit model symmetry 0 result-string )
     (fli:convert-from-foreign-string result-string))))

;(time(c-allintervalG 12 0 :model 2))

;;;;;;;;;;;;;;;;;;
;; HAMMING CODES
;;;;;;;;;;;;;;;;;;
;; load the frameworks (one per model)
(setf hamming-path (make-pathname :directory Frameworks-directory :name "hamming-constraints.framework/Versions/A/hamming-constraints"))
(fli:register-module "hamming-constraints" :real-name hamming-path)

;version dev:
;(fli:register-module "hamming-constraints" :real-name "/Users/lemouton/Projets/Contraintes/Gecode/C++\ Examples.3.2/SLMExamples/hamming/build/Release/hamming-constraints.framework/Versions/A/hamming-constraints" :connection-style :immediate)

;; interfaces to C function
(fli:define-foreign-function (hammingG "hammingG" :source)
    ((b :int)
     (d :int)
     (s :int)
     (sol :int)
     (time :int)
     (string2 :pointer))
  :language :c
  :calling-convention :cdecl)


(defun c-hamming (b d s solutions
 &KEY (timelimit 0))
  (fli:with-dynamic-foreign-objects 
      ((result-string (:ef-mb-string :limit 81902)
              :initial-element "Lisp String2"))
 
       (hammingG b d s solutions timelimit result-string )
     (fli:convert-from-foreign-string result-string)))

;(c-hamming 5 2 10 2)



;;;;;;;;;;;;;;;;;;
;; GECHORD
;;;;;;;;;;;;;;;;;;
;; load the frameworks (one per model)

;version de dev :
;(fli:register-module "gechord-constraints" :real-name "/Users/lemouton/Projets/Contraintes/Gecode/C++\ Examples.3.2/SLMExamples/gechords/build/Release/gechord-constraints.framework/Versions/A/gechord-constraints" :connection-style :immediate)

(setf gechord-path (make-pathname :directory Frameworks-directory :name "gechord-constraints.framework/Versions/A/gechord-constraints"))
(fli:register-module "gechord-constraints" :real-name gechord-path )


;; interfaces to C function
(fli:define-foreign-function (gechordG "gechordG" :source)
    ((n :int)
     (string1 :pointer)
     (min :int)
     (max :int)
     (sol :int)
     (time :int)
     (model :int)
   (string2 :pointer))
  :language :c
  :calling-convention :cdecl)


(defun c-gechord (n str min max solutions
 &KEY (timelimit 0) (model 0))
  (fli:with-dynamic-foreign-objects 
 ((c-string1 (:ef-mb-string :limit 256)
               :initial-element "Lisp String1")
      (result-string (:ef-mb-string :limit 819020)
              :initial-element "Lisp String2"))
 (let ((c-string1 (fli::convert-to-dynamic-foreign-string str)))
       (gechordG n c-string1 min max solutions timelimit model result-string)
     (fli:convert-from-foreign-string result-string))))

;(c-gechord 4 "((1 3)(2 4))" 60 0 3)

;(c-gechord 4 "((1 5) (1 2) (0 4) (0 1) (0 12))" 60 0 5 :model 1)

;;;;;;;;;;;;;;;;;;
;; PROFILS
;;;;;;;;;;;;;;;;;;

;; load the frameworks (one per model)
(setf profils-path (make-pathname :directory Frameworks-directory :name "profils-constraints.framework/Versions/A/profils-constraints"))
(fli:register-module "profils-constraints" :real-name profils-path )
; version de dev :
;(fli:register-module "profils-constraints" :real-name "/Users/lemouton/Projets/Contraintes/Gecode/C++\ Examples.3.2/SLMExamples/profils/build/Release/profils-constraints.framework/Versions/A/profils-constraints" :connection-style :immediate)


;; interfaces to C function
(fli:define-foreign-function (profilsG "profilsG" :source)
    ((n :int)
     (string1 :pointer)
     (nn :int)
     (dens_min :int)
     (dens_max :int)
     (n_solutions :int)
     (time :int)
     (string2 :pointer))
  :language :c
  :calling-convention :cdecl)


(defun c-profils (n str nn solutions
                    &KEY (timelimit 0)(min 2)(max 5))
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 256)
               :initial-element "Lisp String1")
       (result-string (:ef-mb-string :limit 81902)
              :initial-element "Lisp String2"))
    (let ((c-string1 (fli::convert-to-dynamic-foreign-string str)))
      (profilsG n c-string1 nn min max solutions timelimit result-string))
    (fli:convert-from-foreign-string result-string)))

;(c-profils 12 "((0 1 1 0 2 1) (0 0 1 1 2 0))" 1 :min 1 :max 6)

;(c-profils 8 "((0 1 1 0 2 1) (0 0 1 1 2 0))" 1)

;(trace profilsG)

;;;;;;;;;;;;;;;;;;
;; INTERPOLATIONS
;;;;;;;;;;;;;;;;;;

;; load the frameworks (one per model)
(setf interpolation-path (make-pathname :directory Frameworks-directory :name "interpolm-constraints.framework/Versions/A/interpolm-constraints"))
(fli:register-module "interpolm-constraints" :real-name interpolation-path )
; version de dev :
;(fli:register-module "profils-constraints" :real-name "/Users/lemouton/Projets/Contraintes/Gecode/C++\ Examples.3.2/SLMExamples/interpolm/build/Release/interpolm-constraints.framework/Versions/A/interpolm-constraints" :connection-style :immediate)


;; interfaces to C function
(fli:define-foreign-function (interpolmG "interpolmG" :source)
    ((string1 :pointer)
     (string2 :pointer)
     (string3 :pointer)
     (string4 :pointer)
    (steps :int)
     (n :int)
     (n_solutions :int)
     (time :int)
     (string5 :pointer))
  :language :c
  :calling-convention :cdecl)


(defun c-interpol ( str1 str2 str3 str4 steps n solutions
 &KEY (timelimit 0))
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 256)
                  :initial-element "Lisp String1")
       (c-string2 (:ef-mb-string :limit 256)
                  :initial-element "Lisp String2")
       (c-string3 (:ef-mb-string :limit 256)
                  :initial-element "Lisp String3")
       (c-string4 (:ef-mb-string :limit 256)
                  :initial-element "Lisp String4")
       (result-string (:ef-mb-string :limit 819020) ; c'est trop : allows very long result strings (81902)
                      :initial-element "Lisp String4"))
    (let ((c-string1 (fli::convert-to-dynamic-foreign-string str1))
          (c-string2 (fli::convert-to-dynamic-foreign-string str2))
          (c-string3 (fli::convert-to-dynamic-foreign-string str3))
          (c-string4 (fli::convert-to-dynamic-foreign-string str4)))  
      (interpolmG c-string1 c-string2 c-string3 c-string4 steps n solutions timelimit result-string))
    (fli:convert-from-foreign-string result-string)))

;(c-interpol "(1 2 3)" "(4 8 6)" "(1 2 3 4 8 6)" "(1)"  5 3 4)
;(c-interpol "(2 2 3)" "(4 5 2)" "(1 2 3 4 5 6)" "(0)" 3 3 1)
;(c-interpol "(1 2 3)" "(5 7 9)" "(1 2 3 4 5 6 7 8 9)" "(0 1 6)" 12 3 100)



;;;;;;;;;;;;;;;;;;
;; MICHAEL J's problems
;;;;;;;;;;;;;;;;;;
;; load the frameworks (one per model)

(setf mj-path (make-pathname :directory Frameworks-directory :name "mj-constraints.framework/Versions/A/mj-constraints"))


;(fli:register-module "mj-constraints" :real-name "/Users/lemouton/Library/Frameworks/mj-constraints.framework/Versions/A/mj-constraints" )
;(fli:register-module "mj-constraints" :real-name "/Applications/OM-6.1/userlibrary/OMGecode/Frameworks/mj-constraints.framework/Versions/A/mj-constraints" )

(fli:register-module "mj-constraints" :real-name mj-path :connection-style :immediate )

;; interfaces to C function
;; 1.version simple : entr�e/sortie chaines de caract�res, une seule solution

(fli:define-foreign-function (jarrellC1 "jarrellD" :source)
    ((n :int)
     (string1 :pointer)
     (string2 :pointer)
     (i1 :int)
     (i2 :int)
     (string3 :pointer))
  :language :c
  :calling-convention :cdecl)


(defun c-jarrell (n x y a b)
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 256)
               :initial-element "Lisp String1")
       (c-string2 (:ef-mb-string :limit 256)
              :initial-element "Lisp String2")
       (c-string3 (:ef-mb-string :limit 256)
              :initial-element "Lisp String3"))
    (let(
         (c-string1 (fli::convert-to-dynamic-foreign-string x))
         (c-string2 (fli::convert-to-dynamic-foreign-string y))
          )
       (jarrellC1 n c-string1 c-string2 a b c-string3 )
     (fli:convert-from-foreign-string c-string3)
)))


;;(c-jarrell 15 "((1(-3 -8))(1(3 8))(1(6 -6)))" "(60 65 66 68 71 76 82)" 60 68)
;;(c-jarrell  15 "((2(-3 -8))(1(3 8))(1(6 -6)))" "(60 65 66 68 71 76 82)" 60 60)
;;(c-jarrell  15 "((1(-3 -8))(1(3 8))(1(6 -6))(1(-6 6))(1(11 -11))(1(-11 11))(1(-3 11)))" "(60 65 66 68 71 76 82)" 0 0)

;; 2. �crit plusieurs solutions dans un fichier (avec de plus en plus de cellules : Branch and bound search
(fli:define-foreign-function (jarrellC2 "jarrellE" :source)
    ((n :int)
     (string1 :pointer)
     (string2 :pointer)
     (i1 :int)
     (i2 :int)
     (i3 :int)
     (string3 :pointer)
     (string4 :pointer)
     )
  :language :c
  :calling-convention :cdecl)

(defun c-jarrell2 (n x y a b c z)
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 256)
               :initial-element "Lisp String1")
       (c-string2 (:ef-mb-string :limit 256)
              :initial-element "Lisp String2")
       (c-string3 (:ef-mb-string :limit 256)
              :initial-element "Lisp String3")
       (result-string (:ef-mb-string :limit 256)
             :initial-element "Lisp String4")
       )
    (let(
         (c-string1 (fli::convert-to-dynamic-foreign-string x))
         (c-string2 (fli::convert-to-dynamic-foreign-string y))
         (c-string3 (fli::convert-to-dynamic-foreign-string z))
          )
       (jarrellC2 n c-string1 c-string2 a b c c-string3 result-string )
     (fli:convert-from-foreign-string result-string)
)))
;;(c-jarrell2 15 "((1(-3 -8))(1(3 8))(1(6 -6)))" "(60 65 66 68 71 76 82)" 0 0 4 "/Users/lemouton/Desktop/tmpjarrell3")

;;;;;;;;;;;;;;;;;;;
;; 3. options : timelimit, mode and search engines 
;; �crit plusieurs solutions dans un fichier

(fli:define-foreign-function (jarrellG "jarrellG" :source)
    ((n :int)
     (string1 :pointer)
     (string2 :pointer)
     (i1 :int)
     (i2 :int)
     (i3 :int)
     (string3 :pointer)
     (i4 :int)
     (i5 :int)
     (i6 :int)
     (string4 :pointer)
     )
  :language :c
  :calling-convention :cdecl)

(defun c-jarrellG (n x y a b c 
                     &KEY (outfile "/tmp/c-jarrellG-out")(timelimit 10000) (model 1)(searchengine 1))
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 256)
               :initial-element "Lisp String1")
       (c-string2 (:ef-mb-string :limit 256)
              :initial-element "Lisp String2")
       (c-string3 (:ef-mb-string :limit 256)
              :initial-element "Lisp String3")
       (result-string (:ef-mb-string :limit 256)
             :initial-element "Lisp String4")
       )
    (let(
         (c-string1 (fli::convert-to-dynamic-foreign-string x))
         (c-string2 (fli::convert-to-dynamic-foreign-string y))
         (c-string3 (fli::convert-to-dynamic-foreign-string outfile))
          )
       (jarrellG n c-string1 c-string2 a b c c-string3 timelimit model searchengine result-string )
     (fli:convert-from-foreign-string result-string)
)))
;;(c-jarrellG 25 "((1(-3 -8))(1(3 8))(1(6 -6)))" "(60 65 66 68 71 76 82)" 0 0 200 :model 1 :searchengine 0 :timelimit 100 :outfile "/Users/lemouton/Desktop/tmpjarrell3")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  some simple and unnecessary tests of the foreign interface:


;(fli:register-module "mj-constraints" :real-name "/Library/Frameworks/mj-constraints.framework/Versions/A/mj-constraints" )
;(fli:register-module "mj-constraints"  :real-name "/Library/Frameworks/mj-constraints.framework/Versions/A/mj-constraints" :connection-style :immediate )
;(fli:register-module "mj-constraints" :real-name "mj-constraints" :connection-style :immediate )


(fli:define-foreign-function (random-string 
                              "random_string" 
                              :source)
   ((length :int)
    (return-string (:reference-return 
                    (:ef-mb-string 
                     :limit 256))))
 :result-type nil
; :lambda-list (length &aux return-string)
 :calling-convention :cdecl)
 
;(random-string 3 "xxxxxxx")
;(fli:print-foreign-modules *standard-output* t)
;(fli:connected-module-pathname "mj-constraints")

;;;;;;;;
;;;;;;;;;;; 
(fli:define-foreign-function (c-concat "concatene" :source)
    ((str1 :pointer)
	(str2 :pointer)
	(i1 :int)
	(i2 :int)
	(str3 :pointer)
	)
  :calling-convention :cdecl)


(defun foo2 (x y)
  (fli:with-dynamic-foreign-objects 
      ((c-string1 (:ef-mb-string :limit 256)
               :initial-element "Lisp String1")
       (c-string2 (:ef-mb-string :limit 256)
              :initial-element "Lisp String2")
       (c-string3 (:ef-mb-string :limit 256)
              :initial-element "Lisp String3"))
    (let(
         (c-string1 (fli::convert-to-dynamic-foreign-string x))
         (c-string2 (fli::convert-to-dynamic-foreign-string y))
         
         )
      (c-concat c-string1 c-string2 1 2 c-string3)
      (fli:convert-from-foreign-string c-string3))))

;;(foo2 "a" "b")
