class PagesController < ApplicationController
	include PagesHelper

	before_filter :authenticate

	def faq
		example_motions

	end
end
