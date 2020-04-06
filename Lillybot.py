import discord
from discord.ext import commands
from discord.role import Role

realCode = ''
channelName = ''
readTheRulesRole = 0
token = ''

description = '''A bot to gatekeep the permissions of a discord server.'''

bot = commands.Bot(command_prefix='_', description=description)

async def get_if_has_role(member: discord.Member, ctx):
    if ctx.guild.get_role(readTheRulesRole) not in member.roles:
        return True
    else:
        return False

@bot.event
async def on_ready():
    print('Starting Lillybot')
    print('Logged in as')
    print(bot.user.name)
    print(bot.user.id)
    print('------')

@bot.command(name='RuleCode', description='Read the rules to figure out the rule code.')
async def rulecode(ctx, *code: str):
    if ctx.channel.name == channelName:
        if ctx.author.bot == False:
            if await get_if_has_role(ctx.guild.get_member(ctx.author.id), ctx):
                testCode = ' '.join([str(x) for x in code])
                if testCode == realCode:
                    role = ctx.guild.get_role(readTheRulesRole)
                    await ctx.message.delete()
                    await ctx.send('Thank you, {0.author.display_name}, for reading the rules!'.format(ctx), delete_after=10)
                    await ctx.guild.get_member(ctx.author.id).add_roles(role, reason='{0.author.display_name} read the rules.'.format(ctx))
                else:
                    await ctx.message.delete()
                    await ctx.send('Sorry that was not the right code.', delete_after=10)
            else:
                await ctx.message.delete()
        else:
            await ctx.message.delete()
    else:
        await ctx.message.delete()


bot.run(token)
