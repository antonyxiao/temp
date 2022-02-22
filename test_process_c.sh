echo "============== Test 1 ==============";
./process_cal_c --start=2022/10/10 --end=2022/11/30 --file=aston-martin-release.xml | diff test01.txt - -s
echo "============== Test 2 ==============";
./process_cal_c --start=2022/1/1 --end=2022/2/28 --file=aston-martin-release.xml | diff test02.txt - -s
echo "============== Test 3 ==============";
./process_cal_c --start=2022/3/1 --end=2022/3/20 --file=2022-season-testing.xml | diff test03.txt - -s
echo "============== Test 4 ==============";
./process_cal_c --start=2022/2/1 --end=2022/3/15 --file=2022-season-testing.xml | diff test04.txt - -s
echo "============== Test 5 ==============";
./process_cal_c --start=2022/10/1 --end=2022/11/30 --file=2022-f1-races-americas.xml | diff test05.txt - -s
echo "============== Test 6 ==============";
./process_cal_c --start=2022/10/23 --end=2022/11/12 --file=2022-f1-races-americas.xml | diff test06.txt - -s
echo "============== Test 7 ==============";
./process_cal_c --start=2022/3/1 --end=2022/12/31 --file=2022-f1-races-americas.xml | diff test07.txt - -s
