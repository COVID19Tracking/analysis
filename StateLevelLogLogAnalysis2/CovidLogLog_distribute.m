%% Log-log analysis of 50 (+6) states using Covid-Tracking Data from 30 March 2020
% Please let me know any questions or comments (Dan Butts dab@umd.edu)


% Load data
load CovidData0330.mat
% This matfile was created from the Covid-Tracking Project Data (https://covidtracking.com/us-daily/)
% variables are:
%   statelist: two-letter abbreviation of state used in database 'char(statelist)' will list them
%   thedate: cell array of date ranges for each of 56 states
%   ndetect: cell array with the cumulative number of positives for each state
%   ndead: cell array with number of reported deaths for each state
%   grades: grades of each state from data base (A, B, C, and n/a -> n)

NSTATES = length(ndetect);

%% SMOOTH DATA and Calc New Cases per day 
for cc = 1:NSTATES
	nsmooth{cc} = ndetect{cc};
	NT = length(nsmooth{cc})-1;
	% This is not fancy smoothing.
	for nn = [2 NT-1]
		% 3-average boxcar filter
		nsmooth{cc}(nn) = (ndetect{cc}(nn) + ndetect{cc}(nn-1) + ndetect{cc}(nn+1))/3;
	end
	for nn = 3:NT-2
		% 5-average boxcar
		nsmooth{cc}(nn) = (ndetect{cc}(nn) + ndetect{cc}(nn-1) + ndetect{cc}(nn-2) + ndetect{cc}(nn+1)+ndetect{cc}(nn+2))/5;
	end
	
	% Calculate number of new cases per day (implicitly starts with zero)
	nderv{cc} = diff([ndetect{cc}(1) ndetect{cc}]);
	ndervsm{cc} = diff([nsmooth{cc}(1) nsmooth{cc}]);
end

%% Plot all state data on one plot, with lines that infer rate of exponential process
tosmooth = 1; % or 0

figure; hold on
for cc = 1:NSTATES
	if tosmooth
		plot(log2(nsmooth{cc}(1:end)),log2(ndervsm{cc}), 'b')
		plot(log2(nsmooth{cc}(1:end)),log2(ndervsm{cc}), 'b.')
	else
		plot(log2(ndetect{cc}(1:end)),log2(nderv{cc}), 'b')
		plot(log2(ndetect{cc}(1:end)),log2(nderv{cc}), 'b.')
	end
end
plot([0 16],[0 16], 'k','LineWidth', 1.5)  % time-scale -> 0 line
if tosmooth
	plot([0 16],[0 16]+log2(1-2^(-1/4)), 'm--','LineWidth', 1.5)  % double every 4 days
	plot([0 16],[0 16]+log2(1-2^(1/2)), 'r','LineWidth', 1.5) % double every 2 days
end
axis([0 16 0 14])

%% Make 2 pages with all 50 states, 30 plots per page
% order states by grade
% Order by grade
state_order = zeros(NSTATES,1);
nsofar = 0;
for nn = 1:4
	switch(nn)
		case 1, a = find(grades == 'A');
		case 2, a = find(grades == 'B');
		case 3, a = find(grades == 'C');
		case 4, a = find(grades == 'n');
	end
	state_order(nsofar+(1:length(a))) = a;
	nsofar = nsofar + length(a);
end


NPP = 30;
for pages = 1:ceil(NSTATES/NPP)
	figure
	for aa = 1:NPP
		if (pages-1)*NPP+aa <= NSTATES
			subplot(5,6,aa); hold on
			for cc = 1:NSTATES
				plot(log2(nsmooth{cc}(1:end)),log2(ndervsm{cc}), 'g')
			end
			%plot([0 16],[0 16], 'k')
			plot([0 16],[0 16]+log2(1-2^(1/2)), 'r')
			cc = state_order((pages-1)*NPP+aa);
			plot(log2(nsmooth{cc}(1:end)),log2(ndervsm{cc}), 'k', 'LineWidth', 1)
			plot(log2(nsmooth{cc}(1:end)),log2(ndervsm{cc}), 'k.')
			
			set(gca, 'XTick', 0:4:16, 'YTick', 0:4:12)
			title(sprintf('%s: %c', char(statelist(cc,:)), char(grades(cc))))
			axis([0 16 0 14])
		end
	end
end



