class Handler
  def call(env)
    doc = <<'DOC'
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
%head
  %meta{"http-equiv"=>"refresh", "content"=>"300"}
  %title Velocity and Variance
  :css
    body {
      background: #F0F0F0;
    }
    .theText {
        color: #666;
        font: 24px Arial, sans-serif;
        font-weight:bold;
    }
    .theTextRight {
        color: #666;
        font: 24px Arial, sans-serif;
        font-weight:bold;
        text-align: right;
        float: right;
    }
    .theTextLeft {
        color: #666;
        font: 24px Arial, sans-serif;
        font-weight:bold;
        text-align: left;
        float: left;
    }
    .theChart {
        height: 192px;
        width: 292px;
        border: 8px solid #666;
        padding: 10px 10px 10px 10px;
        color: #666;
        background: #fff;
    }
%body
%div{:class=>"theText"}
- projects.each do |project|
  %div{:style=>"float:left;padding:24px;"}
    %div{:class=>"theChart"}
      %div{:class=>"theText"}
        = project[:name]
      %div{:style=>"padding:10px 0px 0px 0px;"}
        %img{:src => "http://chart.apis.google.com/chart?cht=bvs&chd=t:#{project[:recent_velocities]}&chs=264x120&chds=0,32&chco=88c2e5&chbh=17,1&chf=bg,s,FFFFFF00&chxt=x,y&chxs=0,000000,1,0,_|1,000000,1,0,_&chxl=0:||1:|"}
      %div{:class=>"theTextRight"}
        variance #{project[:stdev].to_i}
      %div{:class=>"theTextLeft"}
        velocity #{project[:current_velocity]}

</html>
DOC
    [200, {"Content-Type" => "text/html"}, [Haml::Engine.new(doc).to_html(Object.new, :projects => Harvester.find_projects)]]
  end
end