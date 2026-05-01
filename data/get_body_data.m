function body = get_body_data(body_name)

    switch lower(body_name)
    
        case 'moon'
            body.name   = 'moon';
            body.a      = 384400;          % km
            body.e      = 0.01;
            body.i      = deg2rad(0);
            body.Omega  = deg2rad(0);
            body.omega  = deg2rad(0);
            body.theta  = deg2rad(0);
            body.mu     = 398600;          % km^3/s^2
            body.radius = 1737;            % km
            body.color  = [0.6 0.6 0.6];
        
        case 'moon_like'
            body.name   = 'moon_like';
            body.a      = 384400;          % km
            body.e      = 0.3;             
            body.i      = deg2rad(0);
            body.Omega  = deg2rad(0);
            body.omega  = deg2rad(0);
            body.theta  = deg2rad(0);
            body.mu     = 398600;          % km^3/s^2
            body.radius = 1737;            % km
            body.color  = [0.6 0.6 0.6];

        case 'iss'
            body.name   = 'ISS';
            body.a      = 6780;            % km
            body.e      = 0.01;
            body.i      = deg2rad(0);
            body.Omega  = deg2rad(0);
            body.omega  = deg2rad(0);
            body.theta  = deg2rad(0);
            body.mu     = 398600;          % km^3/s^2
            body.radius = NaN;             % not needed for plotting as sphere
            body.color  = [1 0 0];

        case 'iss_like'
            body.name   = 'ISS';
            body.a      = 6780;            % km
            body.e      = 0.2;
            body.i      = deg2rad(0);
            body.Omega  = deg2rad(0);
            body.omega  = deg2rad(0);
            body.theta  = deg2rad(0);
            body.mu     = 398600;          % km^3/s^2
            body.radius = NaN;             % not needed for plotting as sphere
            body.color  = [1 0 0];

        otherwise
            error('Unknown body: %s', body_name);
    end
end