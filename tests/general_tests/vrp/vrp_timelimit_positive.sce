// Check if the value of the 'time_limit', if given, is positive


adj_matrix =	[0 46 103 101 138 66 70 39 120 107 85 143 40 53 38 92 31 83 107 84 49 78 111 107 35 94 23 32 120 68 19 87 ;
		46 0 85 83 120 112 52 17 102 89 131 125 10 31 50 116 15 47 89 44 95 32 93 89 53 140 27 64 102 102 27 41 ;
		103 85 0 4 39 105 33 68 55 72 124 50 95 54 65 109 84 44 58 45 88 57 82 12 68 133 80 71 37 95 90 48 ;
		101 83 4 0 37 101 31 66 51 68 120 46 93 52 63 105 82 48 54 49 86 55 78 8 66 129 78 69 33 91 88 52 ;
		138 120 39 37 0 98 68 103 18 33 85 11 130 89 100 70 119 83 31 84 123 92 43 31 103 94 115 106 18 70 125 87 ;
		66 112 105 101 98 0 88 105 80 67 33 103 106 119 62 52 97 149 67 150 25 144 71 93 59 28 85 48 80 28 85 153 ;
		70 52 33 31 68 88 0 35 50 55 107 73 62 31 32 92 51 61 41 62 71 56 65 37 35 116 47 40 50 78 57 65 ;
		39 17 68 66 103 105 35 0 85 72 124 108 27 14 43 109 16 44 72 45 88 39 82 72 46 133 20 57 85 95 22 48 ;
		120 102 55 51 18 80 50 85 0 17 69 23 112 71 82 54 101 99 13 100 105 94 27 43 85 78 97 88 18 52 107 103 ;
		107 89 72 68 33 67 55 72 17 0 52 36 99 86 69 37 88 116 14 117 92 111 10 60 72 61 84 75 35 39 94 120 ;
		85 131 124 120 85 33 107 124 69 52 0 74 125 138 81 19 116 168 66 169 58 163 42 112 78 21 104 67 87 29 104 172 ;
		143 125 50 46 11 103 73 108 23 36 74 0 135 94 105 59 124 94 36 95 128 97 32 38 108 91 120 111 23 75 130 98 ;
		40 10 95 93 130 106 62 27 112 99 125 135 0 41 44 110 11 57 99 54 89 38 103 99 47 134 21 58 112 96 21 47 ;
		53 31 54 52 89 119 31 14 71 86 138 94 41 0 57 123 30 30 72 31 102 25 96 58 60 147 34 71 71 109 36 34 ;
		38 50 65 63 100 62 32 43 82 69 81 105 44 57 0 66 35 87 69 88 45 82 73 69 3 90 23 14 82 52 25 91 ;
		92 116 109 105 70 52 92 109 54 37 19 59 110 123 66 0 101 153 51 154 77 148 27 97 63 40 89 60 72 24 89 157 ;
		31 15 84 82 119 97 51 16 101 88 116 124 11 30 35 101 0 52 88 53 80 47 92 88 38 125 12 49 101 87 12 56 ;
		83 47 44 48 83 149 61 44 99 116 168 94 57 30 87 153 52 0 102 3 132 19 126 56 90 177 64 101 81 139 64 10 ;
		107 89 58 54 31 67 41 72 13 14 66 36 99 72 69 51 88 102 0 103 92 97 24 46 72 75 84 75 21 39 94 106 ;
		84 44 45 49 84 150 62 45 100 117 169 95 54 31 88 154 53 3 103 0 133 16 127 57 91 178 65 102 82 140 65 7 ;
		49 95 88 86 123 25 71 88 105 92 58 128 89 102 45 77 80 132 92 133 0 127 96 92 42 45 68 31 105 53 68 136 ;
		78 32 57 55 92 144 56 39 94 111 163 97 38 25 82 148 47 19 97 16 127 0 121 61 85 172 59 96 76 134 59 9 ;
		111 93 82 78 43 71 65 82 27 10 42 32 103 96 73 27 92 126 24 127 96 121 0 70 76 59 88 79 45 43 98 130 ;
		107 89 12 8 31 93 37 72 43 60 112 38 99 58 69 97 88 56 46 57 92 61 70 0 72 121 84 75 25 83 94 60 ;
		35 53 68 66 103 59 35 46 85 72 78 108 47 60 3 63 38 90 72 91 42 85 76 72 0 87 26 11 85 49 26 94 ;
		94 140 133 129 94 28 116 133 78 61 21 91 134 147 90 40 125 177 75 178 45 172 59 121 87 0 113 76 96 38 113 181 ;
		23 27 80 78 115 85 47 20 97 84 104 120 21 34 23 89 12 64 84 65 68 59 88 84 26 113 0 37 97 75 10 68 ;
		32 64 71 69 106 48 40 57 88 75 67 111 58 71 14 60 49 101 75 102 31 96 79 75 11 76 37 0 88 38 37 105 ;
		120 102 37 33 18 80 50 85 18 35 87 23 112 71 82 72 101 81 21 82 105 76 45 25 85 96 97 88 0 58 107 85 ;
		68 102 95 91 70 28 78 95 52 39 29 75 96 109 52 24 87 139 39 140 53 134 43 83 49 38 75 38 58 0 75 143 ;
		19 27 90 88 125 85 57 22 107 94 104 130 21 36 25 89 12 64 94 65 68 59 98 94 26 113 10 37 107 75 0 68 ;
		87 41 48 52 87 153 65 48 103 120 172 98 47 34 91 157 56 10 106 7 136 9 130 60 94 181 68 105 85 143 68 0 ];
	
vehicles = 5;
start = 1;	
	
	
demands = [0 19 21 6 19 7 12 16 6 16 8 14 21 16 3 22 18 19 1 24 8 12 4 8 24 24 2 20 15 2 14 9];

labels = [];

max_vehicle_capacity = 100;
service_time_per_demand = [];
time_windows =[];

waiting_times =[];
speeds = [];
refuel_flag = 0;
fuel_capacity = [];
refuel_nodes = [];

penalty = [];

groups = [];

group_penalty = [];

time_limit = 0;

//Error
// !--error 10000 
//vrp : Positive value expected for the 'time_limit' (argument #17). 
//at line    1031 of function vrp called by :  
// refuel_nodes, penalty, groups, group_penalty, time_limit)
// 



[total_distance, routes ] = vrp( adj_matrix, vehicles, start, labels, demands, max_vehicle_capacity, service_time_per_demand, time_windows, speeds,waiting_times,refuel_flag, fuel_capacity, refuel_nodes, penalty, groups, group_penalty, time_limit);

	
