# Favorites

Find when an annual calendar repeats.
```shell script
calr() {
    YEAR_ARG=$1
    echo "The annual calendar repeats as shown below."
    echo "Non-leap year calendar cycle: 6,11,11 years"
    echo "Leap year calendar cycle:     28 years (6+11+11)"; echo

    for YEAR in {1970..2070}; do
        diff -q <(cal -y $YEAR_ARG | tail -34) <(cal $YEAR | tail -34) > /dev/null && echo $YEAR
    done
}
```

![calr_output](../readme_images/calr_output.png)
