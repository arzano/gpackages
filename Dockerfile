FROM gentoo/portage:latest as portage
FROM gentoo/stage3-amd64

# Need a portage tree to build, use last nights.
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

# Sandbox doesn't work well in docker.
ENV FEATURES="-userpriv -usersandbox -sandbox"
ENV USE="-bindist"

RUN emerge -C openssh
RUN emerge --quiet-build \
    net-libs/nodejs \
    dev-lang/ruby \
    dev-vcs/git
RUN ACCEPT_KEYWORDS="~amd64" emerge --quiet-build sys-apps/yarn

RUN eselect ruby set ruby25

# Bundler is how we install the ruby stuff.
RUN gem install bundler -v 1.17.3

# Needed for changelogs.
RUN git clone https://anongit.gentoo.org/git/repo/gentoo.git /mnt/packages-tree/gentoo/

# Copy code into place.
COPY ./ /var/www/packages.gentoo.org/htdocs/
WORKDIR /var/www/packages.gentoo.org/htdocs/
RUN bundler install
RUN yarn cache clean
RUN yarn install --network-concurrency 1
RUN yarn install --check-files

# Git clones here.
RUN cp /var/www/packages.gentoo.org/htdocs/config/secrets.yml.dist /var/www/packages.gentoo.org/htdocs/config/secrets.yml
RUN sed -i 's/set_me/ENV["SECRET_KEY_BASE"]/'g /var/www/packages.gentoo.org/htdocs/config/secrets.yml
RUN cp /var/www/packages.gentoo.org/htdocs/config/initializers/kkuleomi_config.rb.dist /var/www/packages.gentoo.org/htdocs/config/initializers/kkuleomi_config.rb

# Precompile our assets.
RUN bundle exec rake webpacker:compile
CMD ["bundler", "exec", "thin", "start"]

