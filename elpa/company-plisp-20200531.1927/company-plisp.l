(if (opt)
   (let "Lst" (chop @)
      (when (= "-" (car "Lst"))
         (let "Pre" (++ "Lst")
            (when (member (car "Lst") '("\"" "'"))
               (setq "Pre" (++ "Lst")) )
            (let "Str" (pack "Lst")
               (for "Sym" (all)
                  (and
                     (pre? "Str" "Sym")
                     (getd "Sym")
                     (prinl "Sym" (and (= "-" "Pre") " ")) ) ) ) )
         (let ("Path" (rot (split "Lst" "/"))  "Str" (pack (car "Path")))
            (setq "Path" (and (cdr "Path") (pack (glue "/" @) "/")))
            (for "Sym" (dir "Path" T)
               (when (pre? "Str" "Sym")
                  (prinl "Path"
                     (replace (chop "Sym") " " "\\ ")
                     (if (=T (car (info (pack "Path" "Sym"))))
                        "/"
                        " " ) ) ) ) ) ) ))
