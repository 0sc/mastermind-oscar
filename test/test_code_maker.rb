require 'test_helper'

class CodemakerTest < Minitest::Test
  def setup
    FakeFS.activate!
    FileUtils.mkdir_p('/tmp')

    difficulty  = :beginner
    @recorder   = Mastermind::Oscar::RecordManager
    @recorder.create_save_files
    @recorder = @recorder.new(StringIO.new("Jeff\n"))
    @client     = Mastermind::Oscar::Codemaker.new(difficulty,@recorder)
  end

  def teardown
    FakeFS.deactivate!
  end

  def class_mtds
    mtds = [:start, :generate_code, :init_message, :game_play, :analyze_input, :exact_match, :partial_match, :give_guess_feedback, :code, :timer, :difficulty, :recorder, :out_of_guess?, :quit?, :cheat?, :cheat, :difficulties, :colors, :create_color_string, :is_valid_input?, :congratulations, :congratulation_msg, :save_game, :game_over, :color_code, :guess_again]
  end

  def test_class_object
    mtds = class_mtds
    mtds.each do |mtd|
      assert_respond_to @client, mtd, "Doesn't respond to #{mtd}"
    end
  end

  def test_start
    @client.stub(:generate_code, "") do
      @client.stub(:code, []) do
        @client.stub(:game_play, "xyzz") do
          assert_equal "xyzz", @client.start
        end
      end
    end
  end

  def test_initalization
    assert_instance_of Mastermind::Oscar::Codemaker, @client
  end

  def test_difficulty
    assert_equal :beginner, @client.difficulty
  end

  def test_recorder
    assert_instance_of Mastermind::Oscar::RecordManager, @client.recorder
  end

  def test_generate_code
    length = 4,8,6
    [:beginner, :expert, :intermediate].each_with_index do |lvl, i|
      obj = Mastermind::Oscar::Codemaker.new(lvl,@recorder)
      obj.stub(:rand, 0) do
        obj.generate_code
        assert_equal obj.code.length, length[i]
        assert_equal obj.code.join, "R" * length[i]
      end
    end
  end

  def test_time_obj
    if @client.timer
      assert_instance_of Mastermind::Oscar::TimeManager, @client.timer
    else
      assert_nil @client.timer
    end
  end

  def test_init_message
    @client.stub(:code, 4) do
      assert_nil @client.init_message
    end
  end

  def test_game_play_with_quit
    @client.stub(:get_input, 'q') do
      assert_equal :quit, @client.game_play
    end
  end

  def test_game_play_with_cheat
    @client.stub(:get_input, "c") do
      @client.stub(:code, [1]) do
        # @client.stub(:code,)
        assert_nil @client.game_play
      end
    end
  end

  def test_game_play_with_valid_input
    @client.stub(:get_input, "rrrr") do
      @client.stub(:is_valid_input?, true) do
        @client.stub(:analyze_input, true) do
          @client.stub(:congratulation_msg, "") do
            @client.stub(:save_game, "") do
              if @client.timer
                assert_equal :won, @client.game_play
              else
                assert_raises(NoMethodError){@client.game_play}
              end
            end
          end
        end
      end
    end
  end

  def test_game_play_with_wrong_input
    @client.stub(:get_input, "rrrr") do
      @client.stub(:is_valid_input?, true) do
        @client.stub(:analyze_input, false) do
          @client.stub(:game_over, :end) do
            assert_equal :end, @client.game_play
          end
        end
      end
    end
  end

  def test_get_input_valid
    $stdin = StringIO.new("rrrr\n")
    assert_equal "RRRR", @client.get_input($stdin)
  end

  def test_out_of_guess
    10.times do
      a = rand(10)
      b = rand(10)

      a == b ? assert(@client.out_of_guess?(a, b)): refute(@client.out_of_guess?(a, b))
    end
  end

  def test_valid_quit
    input = %w{Q QUIT QUIET QUAYS QUEEN}
    input.each {|i| assert @client.quit?(i)}
  end

  def test_invalid_quit
    input = ('a'..'z').to_a
    input.delete('q')
    input.each {|i| refute @client.quit?(i)}
  end

  def test_valid_cheat
    assert @client.cheat?('c')
  end

  def test_invalid_cheat
    input = ('a'..'z').to_a
    input.delete('c')
    input.each {|i| refute @client.cheat?(i)}
  end

  def test_cheat
    @client.stub(:color_code, "") do
      assert_nil @client.cheat
    end
  end

  def test_valid_input
    input = %w{RRRR RGBB}
    @client.stub(:code, "RBGY") do
      input.each {|i| assert @client.is_valid_input?(i)}
    end
  end

  def test_invalid_input
    input = %w{T K L O J E} << "A"*5
     @client.stub(:code, "RBGY") do
      input.each {|i| refute @client.is_valid_input?(i)}
    end
  end

  def test_analyze_input_match
    code = %w{R B G Y}
    correct_input = code.join
    wrong_input = "xxxx"
    @client.stub(:code, code) do
      if @client.guess
        assert @client.analyze_input(correct_input)
      else
        assert_raises(NoMethodError){@client.analyze_input(correct_input)}
      end

      @client.stub(:guess, 4) do
        @recorder.stub(:print_to_file, nil) do
          assert @client.analyze_input(correct_input)
          refute @client.analyze_input(wrong_input)
        end
      end
    end
  end

  def test_analyze_input_no_match
    code = "RRGG"
    @client.stub(:code, code) do
      if @client.guess
        refute @client.analyze_input(code)
      else
        assert_raises(NoMethodError){@client.analyze_input(code)}
      end
    end
  end

  def test_exact_match
    code = [] ;input = []; expect= []

    code  << %w{r r g g} << %w{r r g g} << %w{r r g g}  << %w{g r r b} << %w{r b g y} << %w{y y y y}  << %w{b b g r}

    input << %w{r r r r}  << %w{g r r g} << %w{y y g g} << %w{b g g r} << %w{i j k l} << %w{y y v y} << %w{b b g r}

    expect << [0,1]  << [1,3] << [2,3] << [] << [] << [0,1,3] << [0,1,2,3]

    code.each_with_index do |arr, index|
      assert_equal(expect[index], @client.exact_match(arr, input[index]))
    end
  end

  def test_partial_match
    code = []; input = []; exact = []; partial = []

    code  << %w{r r g g} << %w{r r g g} << %w{r r g g}  << %w{g r r b} << %w{r b g y} << %w{y y y y}  << %w{b b g r}

    input << %w{r r r r}  << %w{g r r g} << %w{y y g g} << %w{b g g r} << %w{i j k l} << %w{y y v y} << %w{b b g r}

    exact << [0,1]  << [1,3] << [2,3] << [] << [] << [0,1,3] << [0,1,2,3]

    partial << 0 << 2 << 0 << 3 << 0 << 0 << 0

    code.each_with_index do |arr, index|
      assert_equal(partial[index], @client.partial_match(arr, input[index], exact[index]))
    end
  end

  def test_give_guess_feedback
    assert_nil @client.give_guess_feedback("","","")
  end

  def test_congratulations
    if @client.timer
      assert_equal :won, @client.congratulations
    else
      assert_raises(NoMethodError){@client.congratulations}
    end

    @client.stub(:timer, Mastermind::Oscar::TimeManager.new) do
      @client.timer.stub(:stop_timer, nil) do
        @client.timer.stub(:get_time, 100) do
          @client.stub(:congratulation_msg, nil) do
            @client.stub(:save_game, nil) do
              assert_equal :won, @client.congratulations
            end
          end
        end
      end
    end
  end

  def test_congratulation_msg
    @client.stub(:code, []) do
      assert_nil @client.congratulation_msg("")
    end
  end

  def test_save_game
    @client.stub(:code, []) do
      if @client.guess
        assert_nil @client.save_game(1234)
      else
        assert_raises(NoMethodError){@client.save_game(1234)}
      end

      @recorder.stub(:print_to_file, nil) do
        @recorder.stub(:check_for_top_ten, nil) do
          @client.stub(:timer, Mastermind::Oscar::TimeManager.new) do
            @client.timer.stub(:get_seconds, nil) do
              assert_nil @client.save_game(1234)
            end
          end
        end
      end
    end
  end

  def test_guess_again
    assert_nil @client.guess_again
  end

  def test_color_code
    @client.stub(:code, []) do
      assert_empty @client.color_code
    end
  end

  def test_game_over
    @client.stub(:code, []) do
      if @client.timer
        assert_equal :end, @client.game_over
      else
        assert_raises(NoMethodError){@client.game_over}
      end

      @client.stub(:timer, Mastermind::Oscar::TimeManager.new) do
        timer = @client.timer
        timer.stub(:stop_timer, nil) do
          @client.stub(:color_code, "rrrr") do
            @recorder.stub(:print_to_file, nil) do
              timer.stub(:get_time, nil) do
                assert_equal :end, @client.game_over
              end
            end
          end
        end
      end
    end
  end

  def test_create_color_string
    assert @client.create_color_string
  end

   def test_difficulties
    diff = [:beginner, :intermediate, :expert]
    values=[4,4],[6,5],[8,6]
    diff.each_with_index do |d, i|
      assert_equal(values[i], @client.difficulties(d))
    end
  end
end
