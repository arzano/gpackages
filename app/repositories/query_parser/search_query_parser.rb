require 'parslet'

module SearchQueryParser

  class QueryParser < Parslet::Parser
    rule(:term) { match('[^\s"]').repeat(1).as(:term) }
    rule(:quote) { str('"') }
    rule(:operator) { (str('+') | str('-')).as(:operator) }

    rule(:fieldname) { match('[^\s:"]').repeat(1).as(:fieldname) }
    rule(:field) { (fieldname >> str(':')).as(:field) }

    rule(:phrase) do
      (quote >> (term >> space.maybe).repeat >> quote).as(:phrase)
    end
    rule(:clause) { (operator.maybe >> field.maybe >> (phrase | term)).as(:clause) }
    rule(:space)  { match('\s').repeat(1) }
    rule(:query) { (clause >> space.maybe).repeat.as(:query) }
    root(:query)
  end

  class QueryTransformer < Parslet::Transform
    rule(:clause => subtree(:clause)) do
      if clause[:term]
        TermClause.new(clause[:operator]&.to_s, clause[:field], clause[:term].to_s)
      elsif clause[:phrase]
        phrase = clause[:phrase].map { |p| p[:term].to_s }.join(" ")
        PhraseClause.new(clause[:operator]&.to_s, clause[:field], phrase)
      else
        raise "Unexpected clause type: '#{clause}'"
      end
    end
    rule(:query => sequence(:clauses)) { Query.new(clauses) }
  end

  class Operator
    def self.symbol(str)
      case str
      when '+'
        :must
      when '-'
        :must_not
      when nil
        :should
      else
        raise "Unknown operator: #{str}"
      end
    end
  end

  class TermClause
    attr_accessor :operator, :field, :term

    def initialize(operator, field, term)
      self.operator = Operator.symbol(operator)
      self.field = field
      self.term = term
    end
  end

  class PhraseClause
    attr_accessor :operator, :field, :phrase

    def initialize(operator, field, phrase)
      self.operator = Operator.symbol(operator)
      self.field = field
      self.phrase = phrase
    end
  end

  class Query
    attr_accessor :should_clauses, :must_not_clauses, :must_clauses

    def initialize(clauses)
      grouped = clauses.chunk { |c| c.operator }.to_h
      self.should_clauses = grouped.fetch(:should, [])
      self.must_not_clauses = grouped.fetch(:must_not, [])
      self.must_clauses = grouped.fetch(:must, [])
    end

    def to_elasticsearch
      query = { }

      if should_clauses.any?
        query[:should] = should_clauses.map do |clause|
          clause_to_query(clause)
        end
      end

      if must_clauses.any?
        query[:must] = must_clauses.map do |clause|
          clause_to_query(clause)
        end
      end

      if must_not_clauses.any?
        query[:must_not] = must_not_clauses.map do |clause|
          clause_to_query(clause)
        end
      end

      query
    end

    def clause_to_query(clause)
      case clause
      when TermClause
        match(clause.field, clause.term)
      when PhraseClause
        match_phrase(clause.field, clause.phrase)
      else
        raise "Unknown clause type: #{clause}"
      end
    end

    def match(field, term)
      if field
        {
            :match => {
                field[:fieldname].to_s.to_sym => {
                    :query => term
                }
            }
        }
      else
        {
            :multi_match => {
                :query => term,
                :fields => ["atom^3", "name^2"]
            }
        }
      end
    end

    def match_phrase(field, phrase)
      {
          :match_phrase => {
              field ? field[:fieldname].to_s.to_sym : :name => {
                  :query => phrase
              }
          }
      }
    end
  end
end
