{:user { :dependencies [[pjstadig/humane-test-output "0.8.3"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]
        :plugins [[cider/cider-nrepl "0.12.0"]
                  [lein-try "0.4.3"]
                  [lein-ancient "0.6.15"]
                  [lein-pprint "1.2.0"]
                  [lein-kibit "0.1.8"]]}}
