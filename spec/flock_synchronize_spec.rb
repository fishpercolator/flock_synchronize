require 'spec_helper'

describe FlockSynchronize do
  it 'has a version number' do
    expect(FlockSynchronize::VERSION).not_to be nil
  end
  
  def print_string_n_times(string, n)
      n.times {puts string}
  end
  
  let(:expected) do
      red1000   = "red\n" * 1000
      green1000 = "green\n" * 1000
      blue1000  = "blue\n" * 1000
      /(#{red1000}|#{green1000}|#{blue1000}){3}/
  end
    
  describe '::flock_synchronize' do
      it 'can run synchronized code multiple times within the same process' do
          expect do
              %w{red green blue}.each do |colour|
                  FlockSynchronize.flock_synchronize("colour") do
                      print_string_n_times(colour, 1000)
                  end
              end
          end.to output(expected).to_stdout
      end
      it 'synchronizes code paths with the same key' do
          expect do
              Parallel.each(%w{red green blue}, in_processes: 3) do |colour|
                  FlockSynchronize.flock_synchronize("colour") do
                      print_string_n_times(colour, 1000)
                  end
              end
          end.to output(expected).to_stdout_from_any_process
      end
      it "doesn't synchronize code paths when keys are different" do
          expect do
              Parallel.each(%w{red green blue}, in_processes: 3) do |colour|
                  FlockSynchronize.flock_synchronize("colour_#{colour}") do
                      print_string_n_times(colour, 1000)
                  end
              end
          end.not_to output(expected).to_stdout_from_any_process
      end
  end
end
